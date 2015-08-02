require 'sinatra/base'
require 'json'

require_relative './logging.rb'
require_relative './error.rb'

require_relative './calculatorrouter.rb'
require_relative './calculatorloader.rb'

class CalculatorApp < Sinatra::Base
  include Logging

  def self.setup(router)
    return self if defined? @router

    logger.debug 'Setting up calculator app'

    @router = router

    self
  end

  def router
    self.class.instance_variable_get '@router'
  end

  get '/:calculator' do
    calculator_name = params[:calculator]

    fields = request.GET.symbolize_keys

    logger.debug "Requested calculator `#{calculator_name}'"

    response = router.handle_request(calculator_name, fields)

    if response.is_a? ApiError
      response = response.to_h
    else
      response = { result: response }
    end

    response.merge! request_fields: fields

    if fields.include?(:jsonp_callback) && !fields[:jsonp_callback].empty?
      content_type :js
      return "#{request.GET['jsonp_callback']}(#{response.to_json})"
    end

    content_type :json
    response.to_json
  end
end
