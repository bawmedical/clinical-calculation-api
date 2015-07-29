require_relative "./classloader.rb"
require_relative "./logging.rb"
require_relative "./error.rb"

class CalculatorLoaderContext < ClassLoaderContext
  include Logging

  FIELD_PREFIX = :field_

  def initialize(classloader, fields = {})
    super classloader

    self.fields = fields
  end

  def fields=(fields)
    @fields = fields
  end

  def fields
    @fields
  end

  def field?(field_name, prefixed = true)
    fields.include? field_name(field_name, prefixed)
  end

  def field_name(name, reverse = false)
    if reverse
      name.to_sym.sub /^#{FIELD_PREFIX.to_s}/, ""
    else
      FIELD_PREFIX + name.to_sym
    end
  end

  def method_missing(symbol, *arguments)
    if symbol.start_with? FIELD_PREFIX
      reversed_name = field_name(symbol, true)

      if !fields.include? reversed_name
        raise NoFieldError, reversed_name
      end

      fields[reversed_name]
    else
      super
    end
  end

  def respond_to?(symbol, include_private = false)
    if include_private && symbol.start_with?(FIELD_PREFIX)
      fields.include? field_name(symbol, true)
    else
      super
    end
  end
end

class CalculatorLoader < ClassLoader
  include Logging

  CALC_EXT = ".rb"

  def initialize
    super CalculatorLoaderContext
  end

  def load_directory(directory)
    logger.debug "Loading directory `#{directory}'"

    Dir.glob(File.join(directory, "*#{CALC_EXT}")).each { |filename| load_file filename }
  end

  def load_calculators(directory)
    logger.debug "Loading calculators from `#{directory}'"

    directories = Dir.glob(File.join(directory, "*")).select do |filename|
      if File.directory? filename
        load_directory filename
      elsif filename.end_with? CALC_EXT
        load_file filename
      end
    end
  end

  def load_file(filename)
    logger.debug "Loading file `#{filename}'"

    loaded_file = super

    if loaded_file.nil?
      logger.warn "Failed to load `#{filename}'"
    else
      logger.debug "Loaded `#{loaded_file.name}' from `#{filename}'"
    end

    loaded_file
  end

  def calculators
    loaded_files.values
  end

  def has_calculator?(name)
    !get_calculator(name.to_sym).nil?
  end

  def get_calculator(name)
    calculators.find { |calculator| calculator.name.to_sym == name.to_sym }
  end
end
