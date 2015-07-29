require "logger"
require "colorize"

module Logging
  @loggers = {}

  def logger
    @logger ||= Logging.logger_for self.class.name
  end

  def log_error(error)
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end

  def self.logger_for(class_name)
    @loggers[class_name] ||= create_logger_for(class_name)
  end

  def self.create_logger_for(class_name)
    logger = Logger.new STDERR
    logger.progname = class_name
    logger.formatter = LogFormatter.new
    logger
  end

  def self.included(base)
    base.define_singleton_method(:logger) do
      @logger ||= Logging.logger_for self.name
    end
  end

  class LogFormatter < Logger::Formatter
    def call(severity, time, progname, msg)
      color = :default

      case severity
        when "DEBUG"
          color = :light_blue
        when "WARN"
          color = :magenta
        when "INFO"
          color = :cyan
        when "ERROR"
          color = :light_red
        when "FATAL"
          color = :light_red
      end

      possible_colors = String.color_codes.keys.delete_if { |sym| sym.to_s.include?("black") || sym.to_s.include?("default") }
      progname_color = possible_colors[progname.hash % possible_colors.length]

      "#{time.strftime("%H:%M:%S")} [#{severity.colorize(color)}] [#{progname.colorize(progname_color)}]: #{msg}\n"
    end
  end
end
