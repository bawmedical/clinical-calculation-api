require 'rubygems'
require 'bundler/setup'

require './lib/calculatorapp.rb'

CalculatorApp.configure do |app|
  app.set :server_settings, { AccessLog: [] }
end

CalculatorApp.setup.run!
