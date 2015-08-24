require_relative './file_loader.rb'
require_relative './logging.rb'
require_relative './error.rb'

class CalculatorLoaderContext
  include Logging

  FIELD_PREFIX = :field_

  def initialize(helperloader)
    @name = nil
    @execute_block = nil
    @fields = {}

    @requested_helpers = []
    @helperloader = helperloader
  end

  def logger_name
    "Calculator (#{name})"
  end

  def name(name = nil)
    @name = name unless name.nil?
    @name
  end

  def call
    @execute_block.call unless @execute_block.nil?
  end

  def execute(&block)
    @execute_block = block
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

  def helperloader=(helperloader)
    @helperloader = helperloader
  end

  def helperloader
    @helperloader
  end

  def helpers
    @helperloader.nil? ? nil : @helperloader.helpers
  end

  def helper?(helper_name)
    @helperloader.has_helper? helper_name
  end

  def require_helpers(*helper_names)
    @requested_helpers += helper_names.map do |name|
      raise ServerError.new("invalid helper `#{name}'") unless helper? name
      name.to_sym
    end
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
    elsif helper?(symbol) && @requested_helpers.include?(symbol)
      helperloader.get_helper(symbol).call(self, *arguments)
    else
      super
    end
  end

  def respond_to?(symbol, include_private = false)
    if include_private && symbol.start_with?(FIELD_PREFIX)
      fields.include? field_name(symbol, true)
    elsif include_private && helper?(symbol) && @requested_helpers.include?(symbol)
      true
    else
      super
    end
  end
end

class CalculatorLoader < FileLoader
  include Logging

  def initialize(helperloader)
    super CalculatorLoaderContext, [ helperloader ]
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
