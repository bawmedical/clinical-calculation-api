require_relative './error.rb'

class CalculatorRouter
  include Logging

  def initialize(loader)
    @loader = loader
  end

  def call_calculator(calculator_name, fields)
    return NotFoundError.new unless @loader.calculator? calculator_name

    calculator = @loader.get_calculator calculator_name
    calculator.fields = fields
    response = calculator.call
    calculator.fields = nil

    response
  end

  def handle_request(calculator_name, fields)
    call_calculator calculator_name, fields
  rescue ApiError => error
    error
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }

    ServerError.new
  end
end
