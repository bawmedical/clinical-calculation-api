require 'net/http'
require 'json'

name :obesity_by_postcode

electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__)
# local_authority_hash = read_json('./data/obesity&excess_weight_by_LA.json', __FILE__)

execute do

  # Retrieve fields from request
  postcode_search = get_field :postcode_search

  uri = URI('http://mapit.mysociety.org/postcode/' + URI.escape(postcode_search))

  postcode_data = JSON.parse(Net::HTTP.get(uri)).symbolize_keys

  fail FieldError.new('postcode_search', 'invalid postcode') if postcode_data.include? :code

  response = {}
  postcode_data[:areas].each { |_k, v| response[:ward] = v[:name] if v[:type_name].match(/ward/) }
  # postcode_data["areas"].each { |k,v| response[:local_authority] = v["name"] if v["type_name"]=="what goes here?" }

  response[:obesity_by_ward] = electoral_ward_hash[response[:ward]]
  response
end
