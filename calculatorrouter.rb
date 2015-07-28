class CalculatorRouter
  include Logging

  ERRORS = {
    invalid_request: { error: 400, message: "Invalid request" },
    not_found: { error: 404, message: "Not found" },
    server_error: { error: 500, message: "Server error" }
  }

  def initialize(loader)
    @loader = loader
  end

  def endpoint?(endpoint_name)
    !get_endpoint(endpoint_name).nil?
  end

  def get_endpoint(endpoint_name)
    @loader.get_calculators.find { |calculator| calculator.get_endpoint == endpoint_name }
  end

  def handle_endpoint(endpoint_name, data)
    logger.info "Handling endpoint `#{endpoint}' with data `#{data}'"
  end


end
