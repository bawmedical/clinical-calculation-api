require 'rubygems'
require 'bundler/setup'

require './lib/ext/string.rb'
require './lib/ext/symbol.rb'

require './lib/calculatorapp.rb'
require './lib/calculatorloader.rb'
require './lib/calculatorrouter.rb'

if __FILE__ == $0
  CalculatorApp.configure do |app|
    app.set :server_settings, { AccessLog: [] }
  end

  loader = CalculatorLoader.new
  router = CalculatorRouter.new loader

  loader.load_calculators './calculators'

  CalculatorApp.setup(router).run!
end
