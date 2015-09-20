class BmiCalculator < Calculator
  def bmi(_fields, helpers)
    weight = helpers.get_field_as_float :weight_in_kg
    height = helpers.get_field_as_float :height_in_m

    fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
    fail FieldError.new('height', 'must be greater than zero') if height <= 0

    { value: weight / (height**2), units: 'kg/m^2' }
  end

  endpoint :bmi
end
