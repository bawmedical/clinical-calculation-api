name :search_electoral_wards

electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__)

execute do

  # Retrieve fields from request
  search_string = get_field :search

  electoral_ward_hash.keys.grep(/#{search_string}/)
end
