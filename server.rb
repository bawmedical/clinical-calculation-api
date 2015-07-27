require 'rubygems'
require 'bundler/setup'

require './logging.rb'

require './calculator.rb'
require './calculatorloader.rb'
require './calculatorapp.rb'

CalculatorApp.configure do |app|
  app.set :server_settings, { AccessLog: [] }
end

CalculatorApp.setup.run!
