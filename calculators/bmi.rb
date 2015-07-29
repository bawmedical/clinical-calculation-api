name :bmi

execute do
	raise FieldError.new("weight", "weight must be greater than zero") if field_weight <= 0
	raise FieldError.new("height", "height must be greater than zero") if field_height <= 0

	field_weight / (field_height ** 2)
end
