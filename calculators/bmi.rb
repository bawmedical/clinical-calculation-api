name :bmi

execute do
	next Errors::INVALID_REQUEST.clone message: "weight must be greater than zero" if field_weight <= 0
	next Errors::INVALID_REQUEST.clone message: "height must be greater than zero" if field_height <= 0
	
	field_weight / (field_height ** 2)
end