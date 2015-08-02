require 'logger'
require 'zlib'
require 'colorize'

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
      @logger ||= Logging.logger_for name
    end
  end

  class LogFormatter < Logger::Formatter
    def self.get_color(severity)
      case severity
      when 'DEBUG' then :light_blue
      when 'WARN'  then :magenta
      when 'INFO'  then :cyan
      when 'ERROR' then :light_red
      when 'FATAL' then :light_red
      else :default
      end
    end

    def call(severity, time, progname, msg)
      color = LogFormatter.get_color severity

      possible_colors = String.color_codes.keys.delete_if do |sym|
        sym.include?(:black) || sym.include?(:default)
      end

      progname_color = possible_colors[Zlib.crc32(progname) % possible_colors.length]

      time = time.strftime '%H:%M:%S'
      colored_severity = severity.colorize color
      colored_progname = progname.colorize progname_color

      "#{time} [#{colored_severity}] [#{colored_progname}]: #{msg}\n"
    end
  end
end
