def get_bool(name)
  value = send "field_#{name}"

  begin
    value.to_s.to_bool
  rescue ArgumentError
    raise InvalidRequestError, "#{name} must be a boolean (true/false)"
  end
end

name :cha2ds2

execute do
	raise FieldError.new("age", "age must be a number") if !field_age.is_float?
	raise FieldError.new("sex", "sex must be 'M' or 'F'") if !(field_sex == "M" || field_age == "F")

	congestive_heart_failure_history = get_bool("congestive_heart_failure_history")
	hypertension_history = get_bool("hypertension_history")
	stroke_history = get_bool("stroke_history")
	vascular_disease_history = get_bool("vascular_disease_history")
	diabetes = get_bool("diabetes")

	age = field_age.to_i
	sex = field_sex.to_s

	score = 0

	score += 1 if (age > 65) && (age < 74)
	score += 2 if (age >= 75)

	score += 1 if sex == "F"

	score += 1 if congestive_heart_failure_history
	score += 1 if hypertension_history
	score += 2 if stroke_history
	score += 1 if vascular_disease_history
	score += 1 if diabetes

	score
end