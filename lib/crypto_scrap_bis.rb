require 'nokogiri'
require 'open-uri'
require 'pry'

=begin
Ce programme permet de scrapper les prix des cryptomonnaies sur le site CoinMarketCap.
Il utilise la gem nokogiri pour parser le HTML de la page et récupérer les informations sur les cryptomonnaies.
Il affiche ensuite le symbole et le prix de chaque cryptomonnaie.
Le programme est limité à 20 lignes car le site plafonne le nombre de lignes scrappées à 20.
=end

def crypto_scrap2
  # URL de la page à scraper
  url = 'https://coinmarketcap.com/all/views/all/'

  # Ouvrir l'URL et lire le contenu
  doc = Nokogiri::HTML(URI.open(url))

  # Vérifier si la page a été chargée correctement
  if doc.nil?
    puts "Erreur lors du chargement de la page."
    return
  end

  # Initialiser un tableau pour stocker les informations
  crypto_data = []

  # Sélectionner les lignes du tableau contenant les informations sur les cryptomonnaies avec XPath
  rows = doc.xpath('//table//tbody//tr')

  # Vérifier si le tableau est vide
  if rows.empty?
    puts "Aucune donnée trouvée sur la page."
    return
  end

  # Parcourir chaque ligne et extraire les informations
  rows.each_with_index do |row, index|
    break if index >= 20 # Limiter à 20 lignes pour éviter de surcharger la sortie

    # Extraire le symbole de la cryptomonnaie
    symbol = row.xpath('.//td[3]//div').text.strip rescue nil

    # Extraire le prix de la cryptomonnaie
    price_text = row.xpath('.//td[5]//div//span').text.strip rescue nil

    # Vérifier si les valeurs extraites sont valides
    if symbol.nil? || symbol.empty? || price_text.nil? || price_text.empty?
      puts "Erreur : Données manquantes pour une ligne à l'index #{index}."
      puts "Contenu de la ligne : #{row.to_html}"
      next
    end

    # Enlever le symbole de dollar et les virgules du prix
    price = price_text.delete('$').delete(',').to_f

    # Vérifier si le prix est valide
    if price == 0.0
      puts "Erreur : Prix invalide pour #{symbol}."
      next
    end

    # Hash pour stocker les informations de chaque cryptomonnaie
    crypto = {
      symbol: symbol,
      price: price.round(2)
    }

    # Ajouter le hash au tableau
    crypto_data << crypto

    # Afficher le symbole et le prix
    puts "#{symbol} : #{price.round(2)}"
  end
end

# Appeler la méthode pour lancer le scraping
crypto_scrap2