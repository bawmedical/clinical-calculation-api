require_relative "./error.rb"

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
      return InvalidRequestError.new "Field `#{invalid_field}' must be a float"
    end

    fields = (fields.map { |k, v| [ k, Float(v) ] }).to_h

    begin
      return NotFoundError.new unless @loader.has_calculator? calculator_name

      calculator = @loader.get_calculator calculator_name
      calculator.fields = fields
      response = calculator.call
      calculator.fields = nil

      response
    rescue ApiError => error
      error
    rescue => error
      logger.error "Error: #{error.message}"
      error.backtrace.each { |line| logger.error line }

      ServerError.new
    end
  end
end
