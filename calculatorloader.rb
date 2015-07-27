class CalculatorLoader
  alias_method :reload, :load
  include Logging

  CALCULATOR_SUFFIX = '.rb'

  def initialize(path, auto_load = true)
    @calculators = []
    @path = path || './calculators'

    load_calculators if auto_load
  end

  def get_calculators
    ObjectSpace.each_object(Class).select { |clazz| clazz < Calculator }
  end

  def load_calculators
    Dir[File.join(@path, '*' + CALCULATOR_SUFFIX)].map { |name| load name }
    @calculators = get_calculators

    self
  end

  def get_calculator(endpoint_name)
    get_calculators.find { |calculator| calculator.get_endpoint == endpoint_name }
  end
end
