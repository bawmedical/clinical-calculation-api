require_relative './file_loader.rb'
require_relative './logging.rb'
require_relative './calculator_context.rb'

class CalculatorLoader < FileLoader
  include Logging

  def initialize(helperloader)
    super CalculatorContext, [helperloader]
  end

  def load_file(filename)
    loaded_file = super

    if loaded_file.respond_to?(:name) && !loaded_file.name.nil?
      logger.debug "Loaded calculator `#{loaded_file.name}' from `#{filename}'"
    else
      logger.error "Invalid calculator in `#{filename}' (missing name)"
      loaded_files.delete filename
    end

    loaded_file
  end

  def calculators
    loaded_files.values
  end

  def calculator?(name)
    !get_calculator(name.to_sym).nil?
  end

  def get_calculator(name)
    calculators.find { |calculator| calculator.name.to_sym == name.to_sym }
  end
end
