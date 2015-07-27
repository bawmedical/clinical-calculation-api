require 'sinatra/base'
require 'json'

class CalculatorApp < Sinatra::Base
  Calculators.setup

  def handle_request(endpoint, data)

  end

  def invalid_request_response
    { error: 400 }
  end

  def not_found_response
    { error: 404 }
  end

  def server_error_response
    { error: 500 }
  end

  post '/:endpoint' do
    endpoint = Calculators.get_endpoint params[:endpoint]

    if endpoint.nil?
      response = not_found_response
    else
      begin
        data = JSON.parse request.body.read

        begin
          response = handle_request(endpoint, data)

          if response.nil?
            response = server_error_response
          end
        rescue
          response = server_error_response
        end
      rescue
        response = invalid_request_response
      end
    end

    response.to_json
  end
end
