require 'rubygems'
require 'bundler/setup'

require_relative './lib/ext/all.rb'

require_relative './lib/helper_loader.rb'

require_relative './lib/calculator_app.rb'
require_relative './lib/calculator_loader.rb'
require_relative './lib/calculator_router.rb'

require_relative './lib/logging.rb'

def create_calculator_loader
  loader = CalculatorLoader.new
  helper = HelperLoader.new

  loader.load_directory File.expand_path('./calculators', File.dirname(__FILE__))
  helper.load_directory File.expand_path('./helpers', File.dirname(__FILE__))

  { loader: loader, helper_loader: helper }
end

def create_default_router
  loader = create_calculator_loader
  router = CalculatorRouter.new loader[:loader], loader[:helper_loader]

  router
end

def setup_app
  CalculatorApp.setup create_default_router

  CalculatorApp.configure do |app|
    app.set :server_settings, AccessLog: []
  end
end

# HACK: We should find a better way to handle `require'ing this file

if __FILE__ == $PROGRAM_NAME
  logger = Logging.logger_for 'Server'

  CalculatorApp.configure do |app|
    app.set :bind, '0.0.0.0'
  end

  begin
    setup_app.run!
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end
end
