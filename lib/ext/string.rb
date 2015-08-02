class String
  def to_bool
    return true  if self =~ (/^(true|t|yes|y|1)$/i)
    return false if self =~ (/^(false|f|no|n|0)$/i)

    fail ArgumentError, "invalid value `#{self}' for boolean"
  end

  def bool?
    [true, false].include? to_bool
  rescue ArgumentError
    false
  end

  def integer?
    Integer(self).is_a? Integer
  rescue ArgumentError
    false
  end

  def float?
    Float(self).is_a? Float
  rescue ArgumentError
    false
  end

  def pluralize(count, suffix)
    count == 1 ? self : self + suffix
  end
end
