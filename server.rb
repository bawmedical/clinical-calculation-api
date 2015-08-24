require 'rubygems'
require 'bundler/setup'

require_relative './lib/ext/date.rb'
require_relative './lib/ext/hash.rb'
require_relative './lib/ext/module.rb'
require_relative './lib/ext/string.rb'
require_relative './lib/ext/symbol.rb'

require_relative './lib/helper_loader.rb'

require_relative './lib/calculator_app.rb'
require_relative './lib/calculator_loader.rb'
require_relative './lib/calculator_router.rb'

# HACK: We should find a better way to handle `require'ing this file

if __FILE__ == $PROGRAM_NAME
  CalculatorApp.configure do |app|
    app.set :server_settings, AccessLog: []
    app.set :bind, '0.0.0.0'
  end

  logger = Logging.logger_for 'Server'

  helper = HelperLoader.new
  loader = CalculatorLoader.new helper
  router = CalculatorRouter.new loader

  helper.load_directory File.expand_path('./helpers', File.dirname(__FILE__))
  loader.load_directory File.expand_path('./calculators', File.dirname(__FILE__))

  begin
    CalculatorApp.setup(router).run!
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end
end
