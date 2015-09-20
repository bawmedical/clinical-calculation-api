require_relative './logging.rb'

class Calculator
  include Logging

  def endpoints
    endpoint_array = self.class.endpoints.map { |name, mname| [name, mname.nil? ? nil : method(mname)] }
    endpoint_array.to_h
  end

  def self.logger_name
    name.split('::').last
  end

  def self.endpoint(method_name, name: nil)
    name = method_name if name.nil?

    if method_defined? method_name
      endpoints[name] = method_name
    else
      endpoints[name] = nil
    end
  end

  def self.endpoints
    @endpoints ||= {}
  end
end
