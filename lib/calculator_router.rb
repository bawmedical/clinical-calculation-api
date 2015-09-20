require_relative './error.rb'
require_relative './field_hash.rb'
require_relative './method_hash.rb'

class CalculatorRouter
  include Logging

  def initialize(loader, helper_loader)
    @loader = loader
    @helper_loader = helper_loader
  end

  def execute_endpoint(endpoint_name, fields)
    return NotFoundError.new unless @loader.endpoint? endpoint_name

    endpoint = @loader.get_endpoint endpoint_name
    field_hash = FieldHash[fields]
    helper_hash = MethodHash[@helper_loader.helpers]

    endpoint.call(field_hash, helper_hash)
  end

  def handle_request(endpoint_name, fields)
    execute_endpoint endpoint_name, fields
  rescue ApiError => error
    error
  rescue => error
    log_error error

    ServerError.new
  end
end
