class Cha2Ds2Calculator < Calculator
  SCORING = {
    age: [
      # Add 1 point if they are 65-74
      { points: 1, cause: proc { |field| (65..74).include? field } },

      # Add 2 points if they are 75 or older
      { points: 2, cause: proc { |field| field >= 75 } }
    ],

    # Add 1 point if they are female
    sex: { points: 1, cause: :female },

    # Add 1 point if they have a history of congestive heart failure
    congestive_heart_failure_history: { points: 1 },

    # Add 1 point if they have a history of hypertension
    hypertension_history: { points: 1 },

    # Add 2 points if they have a history of Strokes, TIA or Thromboembolism
    stroke_history: { points: 2 },

    # Add 1 point if they have a history of vascular disease
    vascular_disease_history: { points: 1 },

    # Add 1 point if they have diabetes
    diabetes: { points: 1 }
  }

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

    helpers.generate_response helpers.calculate_score(SCORING, fields)
  end

  endpoint :cha2ds2
end
