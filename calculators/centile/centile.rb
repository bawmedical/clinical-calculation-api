require 'date'
require 'json'

name :centile
require_helpers :get_field_as_float, :get_field_as_integer, :months_between, :get_field_as_sex

require_relative "./lib/centilecalculator.rb"

centile_data_path = File.expand_path("./data/lmsdata.json", File.dirname(__FILE__))

if !File.exists? centile_data_path
  logger.error "Missing lmsdata.json!"
  return
end

centile_calculator = CentileCalculator.new JSON.parse (File.read (centile_data_path))

execute do
  weight = get_field_as_float :weight_in_kg
  height = get_field_as_float :height_in_m

  raise FieldError.new("weight", "must be greater than zero") if weight <= 0
  raise FieldError.new("height", "must be greater than zero") if height <= 0

  day_of_birth = get_field_as_integer :day_of_birth
  month_of_birth = get_field_as_integer :month_of_birth
  year_of_birth = get_field_as_integer :year_of_birth

  today = Date.today

  raise InvalidRequestError.new("invalid date of birth") unless Date.valid_date? year_of_birth, month_of_birth, day_of_birth
  raise FieldError.new("year_of_birth", "must be less than #{today.year + 1}") if year_of_birth > today.year

  sex = get_field_as_sex :sex
  bmi = weight / (height ** 2)

  date_of_birth = Date.new year_of_birth, month_of_birth, day_of_birth
  age_in_months = months_between date_of_birth, today

  height_centile = centile_calculator.get_height_centile sex, age_in_months, height * 100
  weight_centile = centile_calculator.get_weight_centile sex, age_in_months, weight
  bmi_centile = centile_calculator.get_bmi_centile sex, age_in_months, bmi

  {
    height_centile: height_centile,
    weight_centile: weight_centile,
    bmi_centile: bmi_centile
  }
end
