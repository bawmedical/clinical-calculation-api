require 'rubygems'
require 'bundler/setup'


require './logging.rb'

require './calculator.rb'
require './calculatorloader.rb'
require './calculatorapp.rb'

CalculatorApp.run!
