require 'nokogiri'
require 'open-uri'

url = "https://www.annuaire-mairie.fr/departement-val-d-oise.html"
base_url = "https://www.annuaire-mairie.fr"

html = URI.open(url, "User-Agent" => "Mozilla/5.0")
page = Nokogiri::HTML(html)

commune_links = page.xpath('//*[@id="habitants_content"]//a')
puts "🔍 Communes trouvées : #{commune_links.size}"

mairies = []

commune_links.each_with_index do |link, index|
  nom = link.text.strip
  commune_url = base_url + link['href']

  begin
    commune_page = Nokogiri::HTML(URI.open(commune_url, "User-Agent" => "Mozilla/5.0"))

    
    email = commune_page.at_xpath('/html/body/div[1]/div[2]/div[1]/p[1]/a')&.text || "Non disponible"

    puts "✅ #{index + 1}. #{nom} : #{email}"
    mairies << { "ville" => nom, "email" => email }

  rescue => e
    puts "⛔ Erreur pour #{nom} : #{e.message}"
  end
end

puts "\n📦 Total mairies extraites : #{mairies.size}"
