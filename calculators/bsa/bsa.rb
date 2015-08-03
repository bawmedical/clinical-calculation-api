name :bsa
require_helpers :get_field_as_float

# Define calculation method
execute do

  # Retrieve fields from request
  weight = get_field_as_float :weight_in_kg
  height = get_field_as_float :height_in_m

  # Ensure fields are valid
  fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
  fail FieldError.new('height', 'must be greater than zero') if height <= 0

  { value: ((weight * (height * 100)) / 3600)**0.5, units: 'm^2' }
end
