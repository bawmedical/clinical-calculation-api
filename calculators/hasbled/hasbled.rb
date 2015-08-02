name :hasbled
require_helpers :get_field_as_bool, :get_field_as_integer

execute do
  hypertension_history = get_field_as_bool :hypertension_history
  renal_disease = get_field_as_bool :renal_disease
  liver_disease = get_field_as_bool :liver_disease
  stroke_history = get_field_as_bool :stroke_history
  prior_major_bleeding = get_field_as_bool :prior_major_bleeding
  predisposition_to_bleeding = get_field_as_bool :predisposition_to_bleeding
  labile_inr = get_field_as_bool :labile_inr
  age = get_field_as_integer :age
  medication_usage_predisposing_to_bleeding = get_field_as_bool :medication_usage_predisposing_to_bleeding
  alcohol_or_drug_history = get_field_as_bool :alcohol_or_drug_history

  score = 0
  score += 1 if hypertension_history
  score += 1 if renal_disease
  score += 1 if liver_disease
  score += 1 if stroke_history
  score += 1 if prior_major_bleeding || predisposition_to_bleeding
  score += 1 if labile_inr
  score += 1 if age > 65
  score += 1 if medication_usage_predisposing_to_bleeding
  score += 1 if alcohol_or_drug_history

  {
    value: score
  }
end
