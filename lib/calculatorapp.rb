require 'sinatra/base'
require 'json'

require_relative './logging.rb'

require_relative './calculatorrouter.rb'
require_relative './calculatorloader.rb'

class CalculatorApp < Sinatra::Base
  include Logging

  def self.setup(router)
    return self if defined? @router

    logger.debug "Setting up calculator app"

    @router = router

    self
  end

  def router
    self.class.instance_variable_get("@router")
  end

  post '/:endpoint' do
    endpoint_name = params[:endpoint]

    logger.debug "Requested #{router.endpoint?(endpoint_name) ? "" : "invalid "}endpoint `#{endpoint_name}'"

    response = router.handle_endpoint(endpoint_name, request.POST)

    response.to_json
  end
end
