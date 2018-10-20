require_relative './lib/centilecalculator.rb'

name :centile

# Load lmsdata from file
centile_calculator = CentileCalculator.new read_json('./data/lmsdata.json', __FILE__)

# Define calculation method
execute do

  # Retrieve fields from request
  weight = get_field_as_float :weight_in_kg
  height = get_field_as_float :height_in_m
  date_of_birth = get_fields_as_date :year_of_birth, :month_of_birth, :day_of_birth
  sex = get_field_as_sex :sex

  today = Date.today

  # Ensure fields are valid
  fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
  fail FieldError.new('height', 'must be greater than zero') if height <= 0
  fail FieldError.new('year_of_birth', 'must be greater than zero') if date_of_birth.year <= 0
  fail FieldError.new('year_of_birth', "must be less than #{today.year + 1}") if date_of_birth.year > today.year

  # Calculate information for centiles
  age_in_months = months_between date_of_birth, today
  bmi = weight / (height**2)

  # Calculate centiles
  height_centile = centile_calculator.get_height_centile sex, age_in_months, height * 100
  weight_centile = centile_calculator.get_weight_centile sex, age_in_months, weight
  bmi_centile = centile_calculator.get_bmi_centile sex, age_in_months, bmi

  # Generate response
  response = {}
  response[:height_centile] = height_centile unless height_centile.nil?
  response[:weight_centile] = weight_centile unless weight_centile.nil?
  response[:bmi_centile] = bmi_centile unless bmi_centile.nil?

  response
end
