require "date"
require "json"

name :centile

require_relative "./lib/centilecalculator.rb"

def months_between(start_date, end_date)
  months = ((start_date - end_date).abs / (365.25 / 12)).round
end

if !File.exists? "./data/lmsdata.json"
  logger.error "Missing lmsdata.json!"
  return
end

centile_calculator = CentileCalculator.new

execute do
end
