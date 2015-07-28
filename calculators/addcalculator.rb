class AddCalculator < Calculator
  endpoint "add"

  def self.calculate(first:, second:)
    first + second
  end
end
