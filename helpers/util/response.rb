require 'json'

def generate_response(_fields, value, units = nil)
  response = { value: value }

  response[:units] = units unless units.nil?

  response
end

add_helper_method method(:generate_response)
