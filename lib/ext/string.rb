class String
  def is_integer?
    begin
      Integer(self).is_a? Integer
    raise ArgumentError
      false
    end
  end

  def is_float?
    begin
      Float(self).is_a? Float
    raise ArgumentError
      false
    end
  end

  alias_method :is_number?, :is_float
end
