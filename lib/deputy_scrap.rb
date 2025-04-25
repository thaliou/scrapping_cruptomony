require 'nokogiri'
require 'open-uri'
require 'pry'

=begin
Ce script permet de scrapper le nom, prénom et le département
des députés français à partir du site de l'Assemblée Nationale.
Cet exercice est à but pédagogique et ne doit pas être utilisé à des fins commerciales.
=end
def deputy_scrap
  # URL de la page à scrapper
  url = 'https://www2.assemblee-nationale.fr/deputes/liste/tableau'

  # Ouvrir l'URL et lire le contenu
  doc = Nokogiri::HTML(URI.open(url))

  # Vérifier si la page a été chargée correctement
  if doc.nil?
    puts "Erreur lors du chargement de la page."
    return
  end

  # Initialiser un tableau pour stocker les informations
  deputy_data = []
  # Sélectionner les lignes du tableau contenant les informations sur les députés
  rows = doc.css('table tbody tr')
  # Vérifier si le tableau est vide
  if rows. empty?
    puts "Aucune donnée trouvée sur la page."
    return
  end

  # test avec pry
  puts "Nombre de lignes trouvées : #{rows.size}"
  #puts "Début de la création du tableau de données"
  #binding.pry

  # Parcourir chaque ligne et extraire les informations
  rows.each_with_index do |row, index|
    break if index >= 20 # Limiter à 20 lignes pour éviter de surcharger la sortie
    # Extraire le texte brut contenant la civilité, le prénom et le nom
    fullname = row.css('td:nth-child(1) a').text.strip rescue nil

    # Vérifier si le texte brut est valide
    if fullname.nil? || fullname.empty?
      puts "Erreur : Données manquantes pour une ligne à l'index #{index}."
      puts "Contenu de la ligne : #{row.to_html}"
      next
    end

    # Supprimer la civilité (ex. "M.", "Mme") et découper pour obtenir le prénom et le nom
    name_parts = fullname.gsub(/^(M\.|Mme|Mlle)\s*/, '').split(' ', 2)
    first_name = name_parts[0]
    name = name_parts[1]

    # Extraire le département du député
    department = row.css('td:nth-child(2)').text.strip rescue nil

    # Vérifier si les valeurs extraites sont valides
    if name.nil? || name.empty? || first_name.nil? || first_name.empty? || department.nil? || department.empty?
      puts "Erreur : Données manquantes pour une ligne à l'index #{index}."
      puts "Contenu de la ligne : #{row.to_html}"
      next
    end

    # Ajouter les informations au tableau
    deputy_data << { name: name, first_name: first_name, department: department }
  end

  # Afficher les informations des députés
  deputy_data.each do |deputy|
    puts "#{deputy[:name]} #{deputy[:first_name]} : #{deputy[:department]}"

  end
  puts "------------------------------------------------------"
  puts "Fin de la création du tableau de données"
end

# Appeler la méthode
deputy_scrap

