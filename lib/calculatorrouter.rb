require_relative './error.rb'

class CalculatorRouter
  include Logging

  def initialize(loader)
    @loader = loader
  end

  def handle_request(calculator_name, fields)
    invalid_fields = fields.keys.select { |k| !fields[k].is_float? }

    if invalid_fields.length > 0
      invalid_field = invalid_fields.first

      logger.debug "Invalid field `#{invalid_field}'"
      return Errors::INVALID_REQUEST.clone message: "Field `#{invalid_field}' must be a float"
    end

    fields = (fields.map { |k, v| [ k, Float(v) ] }).to_h

    begin
      return Errors::NOT_FOUND unless @loader.has_calculator? calculator_name

      calculator = @loader.get_calculator calculator_name
      calculator.fields = fields
      response = calculator.call
      calculator.fields = nil

      return response
    rescue NoFieldError => error
      return Errors::INVALID_REQUEST.clone message: "Missing field `#{error.field}`"
    rescue => error
      logger.error "Error: #{error.message}"
      error.backtrace.each { |line| logger.error line }
      return Errors::SERVER_ERROR
    end
  end
end
