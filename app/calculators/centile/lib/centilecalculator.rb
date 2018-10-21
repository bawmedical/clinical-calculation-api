require 'distribution'

class CentileCalculator
  def initialize(lms_hash)
    @lms_hash = lms_hash.symbolize_keys_select { |k, _v| !k.integer? }
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
    return nil unless sex == :male || sex == :female

    types = @lms_hash[sex]
    return nil unless types.include? type

    type = types[type]
    return nil unless type.include? age.to_s

    lms_to_centile measurement, type[age.to_s]
  end

  def lms_to_centile(x, lms)
    # formulae taken from http://www.cdc.gov/growthcharts/percentile_data_files.htm
    # x is the measurement under consideration
    # returns the percentile as a number from 0 to 100
    # for more information about generating centile values in code, see this blog post: http://www.bawmedical.co.uk/2014/05/10/centiles-doing-them-in-code-part-1/
    l = lms[:l]
    m = lms[:m]
    s = lms[:s]

    if l == 0
      z = log(x / m) / s
    else
      z = (((x / m)**l) - 1) / (l * s)
    end

    Distribution::Normal.cdf(z) * 100
  end
end
