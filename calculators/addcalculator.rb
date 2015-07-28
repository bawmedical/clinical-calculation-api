class AddCalculator < Calculator
  endpoint "add"

  arg_type [:first, :second], :integer

  def self.calculate(first:, second:)
    first + second
  end
end
