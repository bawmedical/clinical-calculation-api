require "rubygems"
require "bundler/setup"

require_relative "./lib/ext/date.rb"
require_relative "./lib/ext/hash.rb"
require_relative "./lib/ext/module.rb"
require_relative "./lib/ext/string.rb"
require_relative "./lib/ext/symbol.rb"

require_relative "./lib/helperloader.rb"

require_relative "./lib/calculatorapp.rb"
require_relative "./lib/calculatorloader.rb"
require_relative "./lib/calculatorrouter.rb"

# HACK: We should find a better way to handle `require'ing this file

if __FILE__ == $0
  CalculatorApp.configure do |app|
    app.set :server_settings, { AccessLog: [] }
    app.set :bind, "0.0.0.0"
  end

  logger = Logging.logger_for "Server"

  helper = HelperLoader.new
  loader = CalculatorLoader.new helper
  router = CalculatorRouter.new loader

  helper.load_helpers "./helpers"
  loader.load_calculators "./calculators"

  begin
    CalculatorApp.setup(router).run!
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end
end
