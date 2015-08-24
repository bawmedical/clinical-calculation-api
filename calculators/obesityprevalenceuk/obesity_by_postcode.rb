require 'net/http'

name :obesity_by_postcode

@electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }
@local_authority_hash = read_json('./data/obesity&excess_weight_by_LA.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do

  # Retrieve fields from request
  postcode_search = get_field :postcode_search

  # Ensure fields are valid
  fail FieldError.new('postcode_search', 'must be a valid(ish) postcode') if !postcode_search.match /(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))/

  uri = URI('http://mapit.mysociety.org/postcode/'+postcode_search)

  postcode_data = JSON.parse (Net::HTTP.get uri)

  response = {}
  postcode_data["areas"].each { |k,v| response[:ward] = v["name"] if v["type_name"].match /ward/ }
  # postcode_data["areas"].each { |k,v| response[:local_authority] = v["name"] if v["type_name"]=="what goes here?" } tricky...

  response[:obesity_by_ward] = @electoral_ward_hash[response[:ward].to_sym]
  response
end
