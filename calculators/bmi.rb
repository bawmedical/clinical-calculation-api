name :bmi

execute do
	raise InvalidRequestError, "weight must be greater than zero" if field_weight <= 0
	raise InvalidRequestError, "height must be greater than zero" if field_height <= 0

	field_weight / (field_height ** 2)
end
