name :list_local_authorities

@local_authority_hash = read_json('./data/obesity&excess_weight_by_LA.json', __FILE__)

execute do
  @local_authority_hash.keys
end
