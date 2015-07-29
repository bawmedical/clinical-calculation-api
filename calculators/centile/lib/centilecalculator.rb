require "distribution"

class CentileCalculator
  module Sex
    MALE = 0
    FEMALE = 1

    def self.from_s(sex)
      result = self.constants.find { |name| name.to_s.casecmp(sex.to_s) == 0 || self.const_get(name).to_s.casecmp(sex.to_s) == 0 }

      return nil if result.nil?

      self.const_get(result)
    end
  end

  def initialize(lms_hash)
    @lms_hash = lms_hash.symbolize_keys_select { |k, v| !k.is_integer? }
  end

  def get_height_centile(sex, age, measurement)
    get_centile sex, age, measurement, :height
  end

  def get_weight_centile(sex, age, measurement)
    get_centile sex, age, measurement, :weight
  end

  def get_bmi_centile(sex, age, measurement)
    get_centile sex, age, measurement, :bmi
  end

  private

  def get_centile(sex, age, measurement, type)
    case sex
      when Sex::MALE
        sex_sym = :male
      when Sex::FEMALE
        sex_sym = :female
      else
        return nil
    end

    types = @lms_hash[sex_sym]
    return nil if !types.include? type

    type = types[type]
    return nil if !type.include? age.to_s

    lms_to_centile measurement, type[age.to_s]
  end

  def lms_to_centile(x, lms)
    # formulae taken from http://www.cdc.gov/growthcharts/percentile_data_files.htm
    # x is the measurement under consideration
    # returns the percentile as a number from 0 to 100
    l = lms[:l]
    m = lms[:m]
    s = lms[:s]

    if l == 0
      z = log(x / m) / s
    else
      z = (((x / m) ** l) - 1) / (l * s)
    end

    Distribution::Normal::cdf(z) * 100
  end
end
