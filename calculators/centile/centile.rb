require_relative './lib/centile.rb'

class CentileCalculator < Calculator
  LMSDATA_PATH = './data/lmsdata.json'

  def initialize
    # Work out path of lmsdata file and load it
    full_path = File.expand_path LMSDATA_PATH, File.dirname(__FILE__)
    @calculator = Centile.new JSON.parse(File.read(full_path))
  end

  def validate_fields(weight, height, date_of_birth)
    fail FieldError.new('weight', 'must be greater than zero') if weight <= 0
    fail FieldError.new('height', 'must be greater than zero') if height <= 0
    fail FieldError.new('year_of_birth', 'must be greater than zero') if date_of_birth.year <= 0
    fail FieldError.new('year_of_birth', "must be less than #{today.year + 1}") if date_of_birth.year > today.year
  end

  def get_centiles(sex, age_in_months, height, weight, bmi)
    # Retrieve centiles
    height_centile = @calculator.get_height_centile sex, age_in_months, height * 100
    weight_centile = @calculator.get_weight_centile sex, age_in_months, weight
    bmi_centile = @calculator.get_bmi_centile sex, age_in_months, bmi

    # Generate response
    response = {}
    response[:height_centile] = height_centile unless height_centile.nil?
    response[:weight_centile] = weight_centile unless weight_centile.nil?
    response[:bmi_centile] = bmi_centile unless bmi_centile.nil?

    response
  end

  def centile(_fields, helpers)
    # Retrieve fields from request
    weight = helpers.get_field_as_float :weight_in_kg
    height = helpers.get_field_as_float :height_in_m
    date_of_birth = helpers.get_fields_as_date :year_of_birth, :month_of_birth, :day_of_birth
    sex = helpers.get_field_as_sex :sex

    today = Date.today

    validate_fields weight, height, date_of_birth

    # Calculate information based on fields
    age_in_months = helpers.months_between date_of_birth, today
    bmi = weight / (height**2)

    get_centiles sex, age_in_months, height, weight, bmi
  end

  endpoint :centile
end
