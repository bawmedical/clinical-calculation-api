require 'sinatra/base'
require 'json'

require './calculatorrouter.rb'
require './calculatorloader.rb'

class CalculatorApp < Sinatra::Base
  include Logging

  def self.setup(loader = nil)
    return self if defined? @router

    logger.debug "Setting up with #{loader.nil? ? "default loader" : "custom loader"}"

    @router = CalculatorRouter.new(loader || CalculatorLoader.new)

    self
  end

  def router
    self.class.instance_variable_get("@router")
  end

  post '/:endpoint' do
    endpoint_name = params[:endpoint]
    endpoint_valid = router.is_endpoint endpoint_name

    logger.debug "Requested #{endpoint_valid ? "" : "invalid "}endpoint `#{endpoint_name}'"

    begin
      data = JSON.parse request.body.read
    rescue JSON::ParserError
      response = CalculatorRouter::ERRORS[:invalid_request]
    end

    if !data.nil?
      router.handle_route(params[:endpoint], data)
    end

    response.to_json
  end
end
