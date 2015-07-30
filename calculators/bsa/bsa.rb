name :bsa

execute do
	raise FieldError.new("weight", "weight must be a number") if !field_weight.is_float?
	raise FieldError.new("height", "height must be a number") if !field_height.is_float?

	weight = field_weight.to_f
	height = field_height.to_f

	raise FieldError.new("weight", "weight must be greater than zero") if weight <= 0
	raise FieldError.new("height", "height must be greater than zero") if height <= 0

	{value: ((weight * height) / 3600) ** 0.5, units: "metres2/kilogram"}
end
