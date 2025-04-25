require 'nokogiri'
require 'open-uri'

def mail_scrapping
  # URL de la page à scrapper
  url = "https://www.annuaire-mairie.fr/departement-val-d-oise.html"
  base_url = "https://www.annuaire-mairie.fr"

  # Ouvrir l'URL et lire le contenu
  # Utilisation de "User-Agent" pour éviter le blocage par le site
  html = URI.open(url, "User-Agent" => "Mozilla/5.0")
  page = Nokogiri::HTML(html)

  # Vérifier si la page a été chargée correctement
  if page.nil?
    puts "Erreur lors du chargement de la page."
    return
  end

  # Extraction des liens vers les communes
  commune_links = page.xpath('//*[@id="habitants_content"]//a')
  puts "🔍 Communes trouvées : #{commune_links.size}"

  # Vérifier si le tableau est vide
  if commune_links.empty?
    puts "Aucune donnée trouvée sur la page."
    return
  end

  # Initialiser un tableau pour stocker les informations
  mairies = []

  # Parcourir chaque ligne et extraire les informations
  commune_links.each_with_index do |link, index|
    nom = link.text.strip
    commune_url = base_url + link['href']
    puts commune_url

    # Vérifier si le lien est valide
    begin
      commune_page = Nokogiri::HTML(URI.open(commune_url, "User-Agent" => "Mozilla/5.0"))

      email = commune_page.at_xpath('/html/body/div[1]/div[2]/div[1]/p[1]/a')&.text || "Non disponible"

      puts "✅ #{index + 1}. #{nom} : #{email}"
      mairies << { "ville" => nom, "email" => email }

    rescue => e
      puts "⛔ Erreur pour #{nom} : #{e.message}"
    end
  end
  # nombres total de mairies extraites
  puts "\n📦 Total mairies extraites : #{mairies.size}"
end

# Appel de la méthode
mail_scrapping
