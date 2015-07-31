name :bsa
require_helpers :get_field_as_float

execute do
	weight = get_field_as_float :weight
	height = get_field_as_float :height

	raise FieldError.new("weight", "weight must be greater than zero") if weight <= 0
	raise FieldError.new("height", "height must be greater than zero") if height <= 0

	{
		value: ((weight * height) / 3600) ** 0.5,
		units: "m^2"
	}
end
