name :hasbled
require_helpers :get_field_as_bool, :get_field_as_integer

# Define calculation method
execute do

  # Retrieve fields from request
  hypertension_history = get_field_as_bool :hypertension_history
  renal_disease = get_field_as_bool :renal_disease
  liver_disease = get_field_as_bool :liver_disease
  stroke_history = get_field_as_bool :stroke_history

  # Ensure at least one bleeding field is present
  fail NoFieldError, 'prior_major_bleeding' unless field?(:prior_major_bleeding) || field?(:predisposition_to_bleeding)

  # TODO: Improve this section (maybe add parameter to get_field_as_* to make it optional?)

  # Make prior_major_bleeding optional by checking if it exists before trying to retrieving it
  prior_major_bleeding =  if field? :prior_major_bleeding
                            get_field_as_bool :prior_major_bleeding
                          else
                            false
                          end

  # Make predisposition_to_bleeding optional by checking if it exists before trying to retrieving it
  predisposition_to_bleeding =  if field? :predisposition_to_bleeding
                                  get_field_as_bool :predisposition_to_bleeding
                                else
                                  false
                                end

  labile_inr = get_field_as_bool :labile_inr
  age = get_field_as_integer :age
  medication_usage_predisposing_to_bleeding = get_field_as_bool :medication_usage_predisposing_to_bleeding
  alcohol_or_drug_history = get_field_as_bool :alcohol_or_drug_history

  score = 0

  # Hypertension History (Uncontrolled, >160 mmHg systolic)
  score += 1 if hypertension_history

  # Renal Disease (Dialysis, transplant, Cr >2.6 mg/dL or >200 umol/L)
  score += 1 if renal_disease

  # Liver Disease (Cirrhosis or Bilirubin >2x Normal or AST/ALT/AP >3x Normal)
  score += 1 if liver_disease

  # Stroke History
  score += 1 if stroke_history

  # Prior Major Bleeding or Predisposition to Bleeding
  score += 1 if prior_major_or_predisposition_to_bleeding

  # Labile INR ((Unstable/high INRs), Time in Therapeutic Range < 60%)
  score += 1 if labile_inr

  # Age > 65
  score += 1 if age > 65

  # Medication Usage Predisposing to Bleeding (Antiplatelet agents, NSAIDs)
  score += 1 if medication_usage_predisposing_to_bleeding

  # Alcohol or Drug Usage History (>= 8 drinks/week)
  score += 1 if alcohol_or_drug_history

  { value: score }
end
