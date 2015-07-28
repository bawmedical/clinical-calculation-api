class AddCalculator < Calculator
  endpoint "add"

  def calculate(first:, second:)
    first + second
  end
end
