name :cha2ds2
require_helpers :get_field_as_integer, :get_field_as_sex, :get_field_as_bool

execute do
	age = get_field_as_integer :age
	sex = get_field_as_sex :sex

	congestive_heart_failure_history = get_field_as_bool :congestive_heart_failure_history
	hypertension_history = get_field_as_bool :hypertension_history
	stroke_history = get_field_as_bool :stroke_history
	vascular_disease_history = get_field_as_bool :vascular_disease_history
	diabetes = get_field_as_bool :diabetes

	score = 0

	score += 1 if (age > 65) && (age < 74)
	score += 2 if (age >= 75)

	score += 1 if sex == :female

	score += 1 if congestive_heart_failure_history
	score += 1 if hypertension_history
	score += 2 if stroke_history
	score += 1 if vascular_disease_history
	score += 1 if diabetes

	{
		cha2ds2_vasc_score: score
	}
end
