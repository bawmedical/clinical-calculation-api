require 'json'

name :obesity_by_electoral_ward
require_helpers :read_json, :get_field

@electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__).symbolize_keys_select { |k, _v| !k.integer? }

execute do 

  # Retrieve fields from request
  electoral_ward_name = get_field :electoral_ward_name

  # Ensure fields are valid
  fail FieldError.new('electoral_ward_name', 'must be a valid electoral ward name') if !@electoral_ward_hash.include? electoral_ward_name.to_sym

  @electoral_ward_hash[electoral_ward_name.to_sym]
end