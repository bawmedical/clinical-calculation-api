name :bmi

# Define calculation method
execute do

  # Retrieve fields from request
  weight = get_field_as_float :weight_in_kg
  height = get_field_as_float :height_in_m

  # Ensure fields are valid
  fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
  fail FieldError.new('height', 'must be greater than zero') if height <= 0

  { value: weight / (height**2), units: 'kg/m^2' }
end
