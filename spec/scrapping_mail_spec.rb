# scrapping_mail_spec.rb
require 'nokogiri'
require 'open-uri'
require 'rspec'

# Fonction de scraping pour récupérer les e-mails des mairies
def fetch_mairie_emails
  url = "https://www.annuaire-mairie.fr/departement-val-d-oise.html"
  html = URI.open(url, "User-Agent" => "Mozilla/5.0")
  page = Nokogiri::HTML(html)

  emails = []

  # Récupère toutes les mairies
  mairies = page.xpath('//*[@id="habitants_content"]//li')

  mairies.each_with_index do |mairie, index|
    mairie_name = mairie.at_xpath('./strong/a')&.text&.strip
    email_link = mairie.at_xpath('./p/a[@href]')&.text&.strip

    if mairie_name && email_link && email_link != "Email non disponible"
      emails << { mairie_name => email_link }
    else
      puts "⛔ Mairie n°#{index + 1} ignorée (email manquant)"
    end
  end

  emails
end

# Tests RSpec
RSpec.describe 'Scraping des e-mails des mairies' do
  let(:emails) { fetch_mairie_emails }

  it 'doit récupérer au moins un e-mail' do
    expect(emails.size).to be > 0
  end

  it 'doit avoir un e-mail pour chaque mairie' do
    emails.each do |email|
      expect(email.keys.first).not_to be_nil
      expect(email.values.first).to match(/\S+@\S+\.\S+/)  # Vérifie si le format de l'email est valide
    end
  end

  it 'doit ignorer les mairies sans e-mail' do
    invalid_email_count = emails.count { |email| email.values.first == "Email non disponible" }
    expect(invalid_email_count).to eq(0)
  end

  it 'doit afficher un message si le e-mail est manquant' do
    expect { fetch_mairie_emails }.to output(/⛔ Mairie n°\d+ ignorée \(email manquant\)/).to_stdout
  end
end
