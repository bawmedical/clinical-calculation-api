class SubCalculator < Calculator
  endpoint "subtract"

  def calculate(first:, last:)
    first - last
  end
end
