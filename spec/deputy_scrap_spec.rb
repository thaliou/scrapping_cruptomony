require 'rspec'
require 'webmock/rspec'
require_relative '../lib/deputy_scrap'

describe '#deputy_scrap' do
  before do
    # Mock the HTTP request to the Assemblée Nationale website
    stub_request(:get, 'https://www2.assemblee-nationale.fr/deputes/liste/tableau')
      .to_return(status: 200, body: File.read('spec/fixtures/deputy_list.html'), headers: { 'Content-Type' => 'text/html' })
  end

  it 'returns an array of hashes with deputy information' do
    result = deputy_scrap
    expect(result).to be_an(Array)
    expect(result).not_to be_empty

    first_deputy = result.first
    expect(first_deputy).to have_key(:name)
    expect(first_deputy).to have_key(:first_name)
    expect(first_deputy).to have_key(:department)
  end

  it 'handles missing or invalid data gracefully' do
    # Mock a response with missing data
    stub_request(:get, 'https://www2.assemblee-nationale.fr/deputes/liste/tableau')
      .to_return(status: 200, body: '<table><tbody><tr><td></td><td></td></tr></tbody></table>', headers: { 'Content-Type' => 'text/html' })

    result = deputy_scrap
    expect(result).to eq([])
  end

  it 'limits the output to 20 deputies' do
    result = deputy_scrap
    expect(result.size).to be <= 20
  end

  it 'raises an error if the page cannot be loaded' do
    # Mock a failed HTTP request
    stub_request(:get, 'https://www2.assemblee-nationale.fr/deputes/liste/tableau')
      .to_return(status: 404)

    expect { deputy_scrap }.to output(/Erreur lors du chargement de la page/).to_stdout
  end
end