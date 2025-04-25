require 'nokogiri'
require 'open-uri'

def mail_scrapping
  # URL de la page à scrapper
  url = "https://www.annuaire-mairie.fr/departement-val-d-oise.html"
  base_url = "https://www.annuaire-mairie.fr"

  # Ouvrir l'URL et lire le contenu
  html = URI.open(url, "User-Agent" => "Mozilla/5.0")
  page = Nokogiri::HTML(html)

  # Vérifier si la page a été chargée correctement
  if page.nil?
    puts "Erreur lors du chargement de la page."
    return
  end

  # Sélectionner les lignes du tableau contenant les informations sur les communes
  commune_table = page.xpath('//table[@class="tblmaire"]//tbody//tr[.//a]')
  puts "🔍 Communes trouvées : #{commune_table.size}"
  # Vérifier si le tableau est vide
  if commune_table.empty?
    puts "Aucune donnée trouvée sur la page."
    return
  end

  # Initialiser un tableau pour stocker les informations
  mairies = []
  errors = 0
  # Parcourir chaque ligne et extraire les informations
  commune_table.each_with_index do |row, index|
    break if index >= 20 # Limiter à 20 lignes pour éviter de surcharger la sortie

    # Extraire le nom de la commune et le lien relatif
    nom = row.xpath('.//a').text.strip rescue nil
    relative_url = row.xpath('.//a/@href').text.strip rescue nil

    # Construire l'URL complète de la commune
    commune_url = base_url + relative_url
    puts commune_url
    # Vérifier si le lien est valide
    begin
      commune_page = Nokogiri::HTML(URI.open(commune_url, "User-Agent" => "Mozilla/5.0"))

      # Extraire l'email de la page de la commune
      #email = commune_page.at_xpath('//div[@id="sideleft"]//a[starts-with(@href, "mailto:")]').text.strip rescue "Non disponible"
      email = commune_page.at_xpath('/html/body/div[1]/div[2]/div[1]/p[1]/a').text.strip rescue "Non disponible"

      # Vérifier si l'email est protégé ou indisponible
      if email.downcase.include?("non disponible") || email.downcase.include?("email protected")
        email = "Email masqué ou protégé"
      end

      puts "✅ #{index + 1}. #{nom} : #{email}"
      mairies << { "ville" => nom, "email" => email }

    rescue => e
      puts "⛔ Erreur pour #{nom} : #{e.message}"
      errors += 1
    end
  end

  # Afficher le nombre total d'erreurs
  puts "\n⛔ Total erreurs : #{errors}"
  # Nombre total de mairies extraites
  puts "\n📦 Total mairies extraites : #{mairies.size}"
end

# Appel de la méthode
mail_scrapping
