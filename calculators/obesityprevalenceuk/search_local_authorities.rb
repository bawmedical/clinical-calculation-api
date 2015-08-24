name :search_local_authorities

@local_authority_hash = read_json('./data/obesity&excess_weight_by_LA.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do

  # Retrieve fields from request
  search_string = get_field :search

  @local_authority_hash.keys.grep /#{search_string}/
end
