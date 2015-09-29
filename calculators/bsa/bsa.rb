class BsaCalculator < Calculator
  def bsa(_fields, helpers)
    weight = helpers.get_field_as_float :weight_in_kg
    height = helpers.get_field_as_float :height_in_m

    fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
    fail FieldError.new('height', 'must be greater than zero') if height <= 0

    result = ((weight * (height * 100)) / 3600)**0.5
    helpers.generate_response result, 'm^2'
  end

  endpoint :bsa
end
