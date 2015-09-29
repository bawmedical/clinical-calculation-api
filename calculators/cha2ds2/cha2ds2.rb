class Cha2Ds2Calculator < Calculator
  SCORING = [
    { points: 1, field: :age, cause: proc { |field| (65..74).include? field } },
    { points: 2, field: :age, cause: proc { |field| field >= 75 } },
    { points: 1, field: :sex, cause: :female },
    { points: 1, field: :congestive_heart_failure_history, cause: true },
    { points: 1, field: :hypertension_history, cause: true },
    { points: 2, field: :stroke_history, cause: true },
    { points: 1, field: :vascular_disease_history, cause: true },
    { points: 1, field: :diabetes, cause: true }
  ]

  def get_score(fields)
    score = 0

    SCORING.each do |item|
      value = fields[item[:field]]

      if item[:cause].respond_to? :call
        score += item[:points] if item[:cause].call value
      else
        score += item[:points] if item[:cause] == value
      end
    end

    score
  end

  def cha2ds2(_fields, helpers)
    fields = {
      age: helpers.get_field_as_integer(:age),
      sex: helpers.get_field_as_sex(:sex),
      congestive_heart_failure_history: helpers.get_field_as_bool(:congestive_heart_failure_history),
      hypertension_history: helpers.get_field_as_bool(:hypertension_history),
      stroke_history: helpers.get_field_as_bool(:stroke_history),
      vascular_disease_history: helpers.get_field_as_bool(:vascular_disease_history),
      diabetes: helpers.get_field_as_bool(:diabetes)
    }

    get_score fields
  end

  endpoint :cha2ds2
end
