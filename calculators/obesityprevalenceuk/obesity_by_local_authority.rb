name :obesity_by_local_authority

@local_authority_hash = read_json('./data/obesity&excess_weight_by_LA.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do

  # Retrieve fields from request
  local_authority_name = get_field :local_authority_name

  # Ensure fields are valid
  fail FieldError.new('local_authority_name', 'must be a valid local authority name') if !@local_authority_hash.include? local_authority_name.to_sym

  @local_authority_hash[local_authority_name.to_sym]
end
