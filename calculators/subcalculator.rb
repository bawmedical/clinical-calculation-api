class SubCalculator < Calculator
  endpoint "subtract"

  def self.calculate(first:, second:)
    first - second
  end
end
