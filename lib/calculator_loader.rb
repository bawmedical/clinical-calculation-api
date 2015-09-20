require_relative './file_loader.rb'
require_relative './logging.rb'
require_relative './calculator.rb'

class CalculatorLoader < FileLoader
  include Logging

  attr_reader :calculators

  def initialize
    super
    @calculators = []
  end

  def load_file(filename)
    loaded_file = super

    if loaded_file.nil?
      logger.error "Failed to load `#{filename}'"
    else
      calculator_classes = loaded_file.classes.select { |c| c < Calculator }
      @calculators.concat calculator_classes.map(&:new)
    end

    loaded_file
  end

  def endpoints
    calculators.map(&:endpoints).reduce({}, :merge).delete_if { |_name, method| method.nil? }
  end

  def endpoint?(name)
    endpoints.key?(name)
  end

  def get_endpoint(name)
    endpoints[name]
  end
end
