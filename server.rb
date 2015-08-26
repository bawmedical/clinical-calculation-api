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

def create_default_router
  helper = HelperLoader.new
  loader = CalculatorLoader.new helper
  router = CalculatorRouter.new loader

  helper.load_directory File.expand_path('./helpers', File.dirname(__FILE__))
  loader.load_directory File.expand_path('./calculators', File.dirname(__FILE__))

  router
end

def setup_app
  CalculatorApp.setup create_default_router
end

if __FILE__ == $PROGRAM_NAME
  CalculatorApp.configure do |app|
    app.set :server_settings, AccessLog: []
    app.set :bind, '0.0.0.0'
  end

  begin
    setup_app.run!
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end
end
