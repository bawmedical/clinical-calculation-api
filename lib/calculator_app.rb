require 'sinatra/base'
require 'json'

require_relative './logging.rb'
require_relative './error.rb'

require_relative './calculator_router.rb'
require_relative './calculator_loader.rb'

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

  get '/:endpoint' do
    endpoint_name = params[:endpoint].to_sym

    fields = request.GET.symbolize_keys

    logger.debug "Requested endpoint `#{endpoint_name}'"

    response = router.handle_request(endpoint_name, fields)

    if response.is_a? ApiError
      response = response.to_h
    else
      response = { result: response }
    end

    response.merge! request_fields: fields

    if fields.include?(:jsonp_callback) && !fields[:jsonp_callback].empty?
      content_type :js
      next "#{request.GET['jsonp_callback']}(#{response.to_json})"
    end

    content_type :json
    response.to_json
  end

  not_found do
    fields = request.GET.symbolize_keys
    response = NotFoundError.new.to_h

    response.merge! request_fields: fields

    if fields.include?(:jsonp_callback) && !fields[:jsonp_callback].empty?
      content_type :js
      next "#{request.GET['jsonp_callback']}(#{response.to_json})"
    end

    content_type :json
    response.to_json
  end
end
