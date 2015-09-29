class Cha2Ds2Calculator < Calculator
  SCORING = [
    # Add 1 point if they are 65-74
    { points: 1, field: :age, cause: proc { |field| (65..74).include? field } },

    # Add 2 points if they are 75 or older
    { points: 2, field: :age, cause: proc { |field| field >= 75 } },

    # Add 1 point if they are female
    { points: 1, field: :sex, cause: :female },

    # Add 1 point if they have a history of congestive heart failure
    { points: 1, field: :congestive_heart_failure_history, cause: true },

    # Add 1 point if they have a history of hypertension
    { points: 1, field: :hypertension_history, cause: true },

    # Add 2 points if they have a history of Strokes, TIA or Thromboembolism
    { points: 2, field: :stroke_history, cause: true },

    # Add 1 point if they have a history of vascular disease
    { points: 1, field: :vascular_disease_history, cause: true },

    # Add 1 point if they have diabetes
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
