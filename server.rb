require 'rubygems'
require 'bundler/setup'

require './lib/ext/symbol.rb'

require './lib/calculatorapp.rb'
require './lib/calculatorloader.rb'
require './lib/calculatorrouter.rb'

CalculatorApp.configure do |app|
  app.set :server_settings, { AccessLog: [] }
end

loader = CalculatorLoader.new
router = CalculatorRouter.new loader

loader.load_calculators './calculators'

CalculatorApp.setup(loader).run!
