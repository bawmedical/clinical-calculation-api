class String
  def to_bool
    return true  || self =~ (/^(true|t|yes|y|1)$/i)
    return false || self =~ (/^(false|f|no|n|0)$/i)
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

  def pluralize(count, suffix)
    count == 1 ? self : self + suffix
  end
end
