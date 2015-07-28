class String
  def is_integer?
    begin
      Integer(self).is_a? Integer
    rescue ArgumentError
      false
    end
  end

  def is_float?
    begin
      Float(self).is_a? Float
    rescue ArgumentError
      false
    end
  end

  alias_method :is_number?, :is_float?
end
