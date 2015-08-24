require_relative './class_loader.rb'
require_relative './logging.rb'
require_relative './error.rb'

class CalculatorLoaderContext < ClassLoaderContext
  include Logging

  FIELD_PREFIX = :field_

  def initialize(classloader)
    super classloader

    @name = nil
    @execute_block = nil
    @fields = {}

    @requested_helpers = []
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

class CalculatorLoader < ClassLoader
  include Logging

  CALC_EXT = ".rb"

  def initialize(helperloader)
    super CalculatorLoaderContext

    @helperloader = helperloader

    @file_dates = {}
  end

  def load_directory(directory)
    logger.debug "Loading directory `#{directory}'"

    Dir.glob(File.join(directory, "*#{CALC_EXT}")).each { |filename| load_file filename }
  end

  def load_calculators(directory)
    logger.debug "Loading calculators from `#{directory}'"

    Dir.glob(File.join(directory, "*")).each do |filename|
      if File.directory? filename
        load_directory filename
      end
    end
  end

  def load_file(filename)
    logger.debug "Loading file `#{filename}'"

    loaded_file = nil

    begin
      loaded_file = super
    rescue => error
      logger.error "Error: #{error.message}"
      error.backtrace.each { |line| logger.error line }
    end

    if loaded_file.nil?
      logger.error "Failed to load `#{filename}'"
    else
      logger.debug "Loaded `#{loaded_file.name}' from `#{filename}'"

      @file_dates[filename] = File.mtime(filename).to_f
    end

    loaded_file
  end

  def calculators
    check_file_dates
    loaded_files.values
  end

  def has_calculator?(name)
    !get_calculator(name.to_sym).nil?
  end

  def get_calculator(name)
    calculators.find { |calculator| calculator.name.to_sym == name.to_sym }
  end

  private

  def get_module(filename, source)
    mod = @context.new self
    mod.helperloader = @helperloader
    mod.instance_eval source, filename

    mod
  end

  def check_file_dates
    @file_dates.each do |filename, date|
      new_date = File.mtime(filename).to_f

      if date != File.mtime(filename).to_f
        logger.debug "File `#{filename}' changed"

        load_file filename
      end
    end
  end
end
