require 'rspec'
require 'webmock/rspec'
require_relative '../lib/crypto_scrap'

describe '#crypto_scrap' do
  before do
    # Mock the HTTP request to CoinMarketCap
    stub_request(:get, 'https://coinmarketcap.com/all/views/all/')
      .to_return(status: 200, body: File.read('spec/fixtures/coinmarketcap.html'))
  end

  it 'returns an array of hashes with symbol and price keys' do
    result = crypto_scrap
    expect(result).to be_an(Array)
    expect(result).to all(be_a(Hash))
    expect(result).to all(include(:symbol, :price))
  end

  it 'limits the result to 20 cryptocurrencies' do
    result = crypto_scrap
    expect(result.size).to eq(20)
  end

  it 'parses the symbol and price correctly' do
    result = crypto_scrap
    expect(result.first[:symbol]).to eq('BTC') # Example symbol
    expect(result.first[:price]).to be_a(Float)
  end

  it 'handles missing or invalid data gracefully' do
    allow_any_instance_of(Nokogiri::HTML::Document).to receive(:css).and_return([])
    expect { crypto_scrap }.to output(/Aucune donnée trouvée sur la page/).to_stdout
  end
end