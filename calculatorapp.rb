require 'sinatra/base'
require 'json'

class CalculatorApp < Sinatra::Base
  include Logging

  ERRORS = {
    invalid_request: { error: 400, message: "Invalid request" },
    not_found: { error: 404, message: "Not found" },
    server_error: { error: 500, message: "Server error" }
  }

  def self.setup(path = nil, auto_load = true)
    return self if defined? @loader

    @loader = CalculatorLoader.new path

    self
  end

  def self.handle_request(endpoint, data)

  end

  post '/:endpoint' do
    p self.methods.sort
    endpoint = @@loader.get_calculator params[:endpoint]

    if endpoint.nil?
      response = ERRORS[:not_found]
    else
      begin
        data = JSON.parse request.body.read

        begin
          response = handle_request(endpoint, data)

          if response.nil?

            response = ERRORS[:server_error]
          end
        rescue
          response = ERRORS[:server_error]
        end
      rescue
        response = ERRORS[:invalid_request]
      end
    end

    response.to_json
  end
end
