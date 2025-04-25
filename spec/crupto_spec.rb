# crypto_spec.rb
require 'nokogiri'
require 'open-uri'
require 'rspec'

# Fonction de scraping pour récupérer les cryptos et leurs cours
def fetch_cryptos
  url = "https://coinmarketcap.com/all/views/all/"
  html = URI.open(url, "User-Agent" => "Mozilla/5.0")
  page = Nokogiri::HTML(html)

  cryptos = []

  # Récupère toutes les lignes du tableau
  lignes = page.xpath('//table//tbody/tr')

  lignes.each_with_index do |ligne, index|
    symbole = ligne.at_xpath('./td[3]')&.text&.strip
    texte_cours = ligne.at_xpath('./td[4]//span')&.text

    if symbole && texte_cours
      cours = texte_cours.gsub(/[^\d.]/, '').to_f
      cryptos << { symbole => cours }
    end
  end

  cryptos
end

# Tests RSpec
RSpec.describe 'Cryptocurrency Scraper' do
  let(:cryptos) { fetch_cryptos }

  it 'doit récupérer au moins une crypto' do
    expect(cryptos.size).to be > 0
  end

  it 'doit avoir des symboles et des cours pour chaque crypto' do
    cryptos.each do |crypto|
      expect(crypto.keys.first).not_to be_nil
      expect(crypto.values.first).to be > 0
    end
  end

  it 'doit avoir un symbole pour la première crypto' do
    first_crypto = cryptos.first
    expect(first_crypto.keys.first).not_to be_empty
  end

  it 'doit avoir un cours pour la première crypto' do
    first_crypto = cryptos.first
    expect(first_crypto.values.first).to be > 0
  end
end



