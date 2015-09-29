# Set the name of the calculator
#
# This is used as the endpoint for the URL, as well as to uniquely identify
# the calculator.
#
# In this case the endpoint would be /example
name :example

# Called when the endpoint is requested
#
# To access a field in the request, use the variable "field_NAME", where
# NAME is the name of the field in the request.
#
# Attempting to get the value of "field_NAME" for a request field that does not exist
# returns an error to the client specifying that the field was missing.
#
# A field can be made optional by retrieving it using "try_field { field_NAME }",
# and in the case that the field is missing, nil will be returned.
#
# You can also access fields using any of the helper methods in "helpers/types/types.rb".
#
# Example #1
# ----------
# Request: /example?hello=world
# The value of "hello" can be accessed using the variable "field_hello".
# All "field_NAME" values are returned as strings.
#
# Example #2
# ----------
# Request: /example?hello=12345
# The integer value of "hello" can be retried using "get_field_as_integer(:hello)"
#
# The return value of the block is used as the response value to the client.
#
# The purpose of this calculator is be a basic calculator which can add and subtract numbers.
execute do

  # Get the first and second values as integers
  first_value = get_field_as_integer(:first)
  second_value = get_field_as_integer(:second)

  # Get the action field
  action = field_action

  # Act upon the action
  case action
  when 'add'

    # Add values
    first_value + second_value
  when 'subtract'

    # Subtract values
    first_value - second_value
  else

    # Return a field error to the client
    fail FieldError.new 'action', 'invalid action (must be add or subtract)'
  end
end
