require 'nokogiri'
require 'open-uri'
require 'pry'

=begin
Ce programme permet de scrapper les prix des cryptomonaies sur le site CoinMarketCap.
Il utilise la gem nokogiri pour parser le HTML de la page et récupérer les informations sur les cryptomonaies.
Il affiche ensuite le symbole et le prix de chaque cryptomonaie.
Le programme estb limité à 20 lignes car le site plafonne le nombre ligne scrappés à 20.
=end

def crypto_scrap
  # URL de la page à scraper
  url = 'https://coinmarketcap.com/all/views/all/'

  # Ouvrir l'URL et lire le contenu
  doc = Nokogiri::HTML(URI.open(url))

  # Vérifier si la page a été chargée correctement
  if doc.nil?
    print "Erreur lors du chargement de la page."
    return
  end

  # Initialiser un tableau pour stocker les informations
  crypto_data = []
  # Sélectionner les lignes du tableau contenant les informations sur les cryptomonaies
  rows = doc.css('table tbody tr')

  # Vérifier si le tableau est vide
  if rows.empty?
    print "Aucune donnée trouvée sur la page."
    return
  end

  # test avec pry
  puts "Nombre de lignes trouvées : #{rows.size}"
  #puts "Début de la création du tableau de données"
  #binding.pry

  # Parcourir chaque ligne et extraire les informations
  rows.each_with_index do |row, index|
    break if index >= 20 # Limiter à 20 lignes pour éviter de surcharger la sortie
    # Extraire le symbole de la cryptomonnaie
    symbol = row.css('td:nth-child(3) div').text.strip rescue nil

    # Extraire le prix de la cryptomonnaie
    price_text = row.css('td:nth-child(5) div span').text.strip rescue nil

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

    # hash pour stocker les informations de chaque cryptomonnaie
    crypto = {
      symbol: symbol,
      price: price.round(2)
    }

    # Ajouter le hash au tableau
    crypto_data << crypto

    # Afficher le symbole et le prix
    puts "#{symbol} : #{price.round(2)}"
  end
  puts "------------------------------------------------------"
  puts "Fin de la création du tableau de données"
end

# appeler la méthode pour lancer le scraping
crypto_scrap