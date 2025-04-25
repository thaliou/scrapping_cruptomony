require 'nokogiri'
require 'open-uri'

puts "🔗 Connexion à CoinMarketCap..."
url = "https://coinmarketcap.com/all/views/all/"
page = Nokogiri::HTML(URI.open(url))
puts "✅ Page chargée avec succès."

cryptos = []

# Récupère toutes les lignes du tableau
lignes = page.xpath('//table//tbody/tr')

puts "📊 Nombre de lignes trouvées : #{lignes.size}"

# Parcours des lignes
lignes.each_with_index do |ligne, index|
  symbole = ligne.at_xpath('./td[3]')&.text&.strip
  texte_cours = ligne.at_xpath('./td[4]//span')&.text

  if symbole && texte_cours
    cours = texte_cours.gsub(/[^\d.]/, '').to_f
    cryptos << { symbole => cours }

    # Puts pour chaque crypto
    puts "💰 Crypto n°#{index + 1} → #{symbole} : #{cours} $"
  else
    puts "⛔ Crypto n°#{index + 1} ignorée (données manquantes)"
  end
end

puts "\n✅ Total final : #{cryptos.size} cryptos enregistrées"

