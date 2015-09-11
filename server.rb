require 'rubygems'
require 'bundler/setup'

require_relative './lib/ext/all.rb'

require_relative './lib/helper_loader.rb'

require_relative './lib/calculator_app.rb'
require_relative './lib/calculator_loader.rb'
require_relative './lib/calculator_router.rb'

def create_calculator_loader
  helper = HelperLoader.new
  loader = CalculatorLoader.new helper

  helper.load_directory File.expand_path('./helpers', File.dirname(__FILE__))
  loader.load_directory File.expand_path('./calculators', File.dirname(__FILE__))

  { helper: helper, loader: loader }
end

def create_default_router
  loader = create_calculator_loader
  router = CalculatorRouter.new loader[:loader]

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
