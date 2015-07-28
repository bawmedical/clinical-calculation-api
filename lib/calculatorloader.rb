require_relative './logging.rb'

class CalculatorLoader
  include Logging

  CALCULATOR_SUFFIX = '.rb'

  def initialize(path = nil)
    @path = path || './calculators'

    load_calculators
  end

  def get_calculators
    ObjectSpace.each_object(Class).select { |clazz| clazz < Calculator }
  end

  def load_calculators
    logger.debug "Loading calculators from `#{@path}'"

    Dir[File.join(@path, '*' + CALCULATOR_SUFFIX)].map do |name|
      load name
      logger.debug "Loaded `#{name}'"
    end

    self
  end

  def get_calculator(endpoint_name)
    get_calculators.find { |calculator| calculator.get_endpoint == endpoint_name }
  end
end
