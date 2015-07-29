class String
  def to_bool
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

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
end
