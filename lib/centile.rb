require 'json'
require 'distribution'

lms_hash = JSON.parse(File.read('data/lmsdata.json'))

class Centile

      # age in months; height in cm, weight in kg!
    def get_height_centile(sex, age_mth, height_cm)
      if sex=="Male"
        return height_centile = lms_to_centile(height_cm, lms_hash['male']['height'][age_mth])
      elsif sex=="Female"
        return height_centile = lms_to_centile(height_cm, lms_hash['female']['height'][age_mth])
      else
        #raise error
      end
    end
  
    def get_weight_centile(sex, age_mth, weight_kg)
      if sex=="Male"
        return weight_centile = lms_to_centile(weight, lms_hash['male']['weight'][age_mth])
      elsif sex=="Female"
        return weight_centile = lms_to_centile(weight, lms_hash['female']['weight'][age_mth])
      else
        #raise error
      end
    end
      
    def get_bmi_centile(sex, age_mth, bmi)
      if sex=="Male"
        return bmi_centile = lms_to_centile(bmi, lms_hash['male']['bmi'][age_mth])
      elsif sex=="Female"
        return bmi_centile = lms_to_centile(bmi, lms_hash['female']['bmi'][age_mth])
      else
        #raise error
      end
    end

    def lms_to_centile(x, lms)
      # formulae taken from http://www.cdc.gov/growthcharts/percentile_data_files.htm
      # x is the measurement under consideration
      # returns the percentile as a number from 0 to 100
      l = lms[0]
      m = lms[1]
      s = lms[2]
      if l==0
        z = log(x/m)/s
      else
        z = (((x/m)**l)-1)/(l*s)
        centile = 100*Distribution::Normal::cdf(z)
      end
      return centile
    end

end
    
puts lms_to_centile(51.04, [1, 51.04, 0.0391])