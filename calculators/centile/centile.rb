require 'date'
require 'json'

name :centile

require_relative "./lib/centilecalculator.rb"

def months_between(start_date, end_date)
  months = ((start_date - end_date).abs / (365.25 / 12)).round
end

centile_data_path = File.expand_path("./data/lmsdata.json", File.dirname(__FILE__))

if !File.exists? centile_data_path
  logger.error "Missing lmsdata.json!"
  return
end

centile_calculator = CentileCalculator.new JSON.parse (File.read (centile_data_path))

execute do

  raise FieldError.new("weight", "weight must be a float") if !field_weight_in_kilograms.is_float?
  raise FieldError.new("height", "height must be a float") if !field_height_in_metres.is_float?
  weight = field_weight_in_kilograms.to_f
  height = field_height_in_metres.to_f
  raise FieldError.new("weight", "weight must be greater than zero") if weight <= 0
  raise FieldError.new("height", "height must be greater than zero") if height <= 0

  raise FieldError.new("day_of_birth", "day_of_birth must be a integer") if !field_day_of_birth.respond_to? :to_i
  day_of_birth = field_day_of_birth.to_i
  raise FieldError.new("day_of_birth", "day_of_birth must be a greater than 0") if day_of_birth <= 0
  raise FieldError.new("day_of_birth", "day_of_birth must be less than 32") if day_of_birth >= 32

  raise FieldError.new("month_of_birth", "month_of_birth must be a integer") if !field_month_of_birth.respond_to? :to_i
  month_of_birth = field_month_of_birth.to_i
  raise FieldError.new("month_of_birth", "month_of_birth must be greater than 0") if month_of_birth <= 0
  raise FieldError.new("month_of_birth", "month_of_birth must be less than 13") if month_of_birth >= 13

  raise FieldError.new("year_of_birth", "year_of_birth must be an integer") if !field_year_of_birth.respond_to? :to_i
  year_of_birth = field_year_of_birth.to_i
  raise FieldError.new("year_of_birth", "year_of_birth must be greater than 1990") if year_of_birth <= 1990
  raise FieldError.new("year_of_birth", "year_of_birth must be less than #{Time.now.year + 1}") if year_of_birth >= Time.now.year + 1
 
  raise FieldError.new("sex", "sex must be 'MALE' or 'FEMALE', in string form") if !(field_sex == "MALE" || field_sex == "FEMALE")

  bmi = weight / (height ** 2)

  date_of_birth = Date.new(year_of_birth, month_of_birth, day_of_birth)
  age_in_months = months_between(date_of_birth, Date.today)
  puts age_in_months

  sex =  CentileCalculator::Sex.from_s field_sex
  puts age_in_months, height
  ht_centile = centile_calculator.get_height_centile(sex, age_in_months, height*100)
  wt_centile = centile_calculator.get_weight_centile(sex, age_in_months, weight)
  bmi_centile = centile_calculator.get_bmi_centile(sex, age_in_months, bmi)

  {height_centile: ht_centile, weight_centile: wt_centile, body_mass_index_centile: bmi_centile, units: "dimensionless"}

end
