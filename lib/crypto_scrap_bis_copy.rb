require 'nokogiri'
require 'open-uri'
require 'pry'

=begin
Ce programme permet de scrapper les prix des cryptomonnaies sur le site CoinMarketCap.
Il utilise la gem nokogiri pour parser le HTML de la page et récupérer les informations sur les cryptomonnaies.
Il affiche ensuite le symbole et le prix de chaque cryptomonnaie.
Le programme scrappe les données par lots de 20 lignes, avec une pause de 2 à 5 minutes entre chaque lot.
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

  # Diviser les lignes en lots de 20
  rows.each_slice(20).with_index do |batch, batch_index|
    puts "Scrapping le lot #{batch_index + 1}..."

    batch.each_with_index do |row, index|
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

    # Pause de 2 à 5 minutes entre chaque lot
    if batch_index < (rows.size / 20) - 1
      sleep_time = rand(120..300) # Pause aléatoire entre 2 et 5 minutes
      puts "Pause de #{sleep_time / 60} minutes avant de continuer..."
      sleep(sleep_time)
    end
  end

  puts "Scrapping terminé. Total de cryptomonnaies scrappées : #{crypto_data.size}"
end

# Appeler la méthode pour lancer le scraping
crypto_scrap2