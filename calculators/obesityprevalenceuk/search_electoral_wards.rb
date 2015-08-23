require 'json'

name :search_electoral_wards
require_helpers :read_json, :get_field

@electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do 

  # Retrieve fields from request
  search_string = get_field :search

  @electoral_ward_hash.keys.grep /#{search_string}/
end