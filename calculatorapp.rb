require 'sinatra/base'
require 'json'

require './calculatorrouter.rb'
require './calculatorloader.rb'

class CalculatorApp < Sinatra::Base
  include Logging

  def self.setup(router = nil, loader = nil)
    return self if defined? @router

    logger.debug "Setting up with #{router.nil? ? "default" : "custom"} router and #{loader.nil? ? "default" : "custom"} loader"

    @router = router || CalculatorRouter.new(loader || CalculatorLoader.new)

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
