require_relative './logging.rb'

class CalculatorContext
  include Logging

  FIELD_PREFIX = :field_

  attr_accessor :fields
  attr_accessor :helperloader

  def initialize(helperloader)
    @name = nil
    @execute_block = nil
    @fields = {}

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

  def field?(field_name, prefixed = true)
    fields.include? field_name(field_name, prefixed)
  end

  def helpers
    @helperloader.nil? ? nil : @helperloader.helpers
  end

  def helper?(helper_name)
    @helperloader.helper? helper_name
  end

  def field_name(name, reverse = false)
    if reverse
      name.to_sym.sub(/^#{FIELD_PREFIX.to_s}/, '')
    else
      FIELD_PREFIX + name.to_sym
    end
  end

  def method_missing(symbol, *arguments, &block)
    if symbol.start_with? FIELD_PREFIX
      reversed_name = field_name(symbol, true)

      fail NoFieldError, reversed_name unless fields.include? reversed_name

      fields[reversed_name]
    elsif helper?(symbol)
      helperloader.get_helper(symbol).call(self, *arguments, &block)
    else
      super
    end
  end

  def respond_to?(symbol, include_private = false)
    if include_private && symbol.start_with?(FIELD_PREFIX)
      fields.include? field_name(symbol, true)
    elsif include_private && helper?(symbol)
      true
    else
      super
    end
  end
end
