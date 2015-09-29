class HasBledCalculator < Calculator
  SCORING = {
    hypertension_history: { points: 1 },
    renal_disease: { points: 1 },
    liver_disease: { points: 1 },
    stroke_history: { points: 1 },
    prior_major_bleeding: { points: 1 },
    predisposition_to_bleeding: { points: 1 },
    labile_inr: { points: 1 },
    age: { points: 1, cause: proc { |field| field > 65 } },
    medication_usage_predisposing_to_bleeding: { points: 1 },
    alcohol_or_drug_history: { points: 1 }
  }

  def get_fields(helpers)
    {
      hypertension_history: helpers.get_field_as_bool(:hypertension_history),
      renal_disease: helpers.get_field_as_bool(:renal_disease),
      liver_disease: helpers.get_field_as_bool(:liver_disease),
      stroke_history: helpers.get_field_as_bool(:stroke_history),
      prior_major_bleeding: helpers.try_field { helpers.get_field_as_bool(:prior_major_bleeding) },
      predisposition_to_bleeding: helpers.try_field { helpers.get_field_as_bool(:predisposition_to_bleeding) },
      age: helpers.get_field_as_integer(:age),
      medication_usage_predisposing_to_bleeding: helpers.get_field_as_bool(:medication_usage_predisposing_to_bleeding),
      alcohol_or_drug_history: helpers.get_field_as_bool(:alcohol_or_drug_history)
    }
  end

  def hasbled(_fields, helpers)
    fields = get_fields helpers

    if fields[:prior_major_bleeding].nil? && fields[:predisposition_to_bleeding].nil?
      fail NoFieldError, 'prior_major_bleeding'
    end

    score = helpers.calculate_score SCORING, fields

    score -= 1 if fields[:prior_major_bleeding] && fields[:predisposition_to_bleeding]

    helpers.generate_response score
  end

  endpoint :hasbled
end
