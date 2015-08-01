class Symbol
  def +(other)
    (self.to_s + other.to_s).to_sym
  end

  def start_with?(value)
    self.to_s.start_with? value.to_s
  end

  def sub(pattern, replacement)
    self.to_s.sub(pattern, replacement.to_s).to_sym
  end

  def include?(substr)
    self.to_s.include? substr.to_s
  end
end
