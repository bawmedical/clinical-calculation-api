name :cha2ds2
require_helpers :get_field_as_integer, :get_field_as_sex, :get_field_as_bool

# Define calculation method
execute do

  # Retrieve fields from request
  age = get_field_as_integer :age
  sex = get_field_as_sex :sex
  congestive_heart_failure_history = get_field_as_bool :congestive_heart_failure_history
  hypertension_history = get_field_as_bool :hypertension_history
  stroke_history = get_field_as_bool :stroke_history
  vascular_disease_history = get_field_as_bool :vascular_disease_history
  diabetes = get_field_as_bool :diabetes

  score = 0

  # Age
  score += 1 if (65..74).include? age
  score += 2 if age >= 75

  # Sex
  score += 1 if sex == :female

  # Congestive Heart Failure History
  score += 1 if congestive_heart_failure_history

  # Hypertension History
  score += 1 if hypertension_history

  # Stroke/TIA/Thromboembolism History
  score += 2 if stroke_history

  # Vascular Disease History
  score += 1 if vascular_disease_history

  # Diabetes Mellitus
  score += 1 if diabetes

  { value: score }
end
