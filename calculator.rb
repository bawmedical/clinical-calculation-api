class Calculator
  def calculate
    raise NotImplementedError
  end

  def self.get_endpoint
    @endpoint || self.name.downcase
  end

  protected
  def self.endpoint(name)
    @endpoint = name.downcase
  end
end
