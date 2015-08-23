require 'net/http'
require 'json'

name :obesity_by_postcode
require_helpers :read_json, :get_field

@electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do 

  # Retrieve fields from request
  postcode_search = get_field :postcode_search

  # Ensure fields are valid
  fail FieldError.new('postcode_search', 'must be a valid(ish) postcode') if !postcode_search.match /(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))/

  postcode_data = Net::HTTP.get 'http://mapit.mysociety.org/postcode/', postcode_search
  postcode_data.include? :type_name "Metropolitan district ward"
end