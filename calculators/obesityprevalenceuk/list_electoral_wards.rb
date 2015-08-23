require 'json'

name :list_electoral_wards
require_helpers :read_json

@electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do 
  @electoral_ward_hash.keys
end