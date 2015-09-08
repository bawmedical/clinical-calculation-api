name :obesity_by_electoral_ward

electoral_ward_hash = read_json('./data/obesity&excess_weight_by_electoral_ward.json', __FILE__)

execute do

  # Retrieve fields from request
  electoral_ward_name = get_field :electoral_ward_name

  # Ensure fields are valid
  unless electoral_ward_hash.include? electoral_ward_name
    fail FieldError.new('electoral_ward_name', 'must be a valid electoral ward name')
  end

  electoral_ward_hash[electoral_ward_name]
end
