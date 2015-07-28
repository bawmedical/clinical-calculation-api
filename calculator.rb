class Calculator
  include Logging

  def calculate
    raise NotImplementedError
  end

  def self.get_endpoint
    @endpoint || self.name.downcase
  end

  def self.get_all_args
    self.instance_method(:calculate).parameters.map { |arg| arg[1] }
  end

  def self.get_required_args
    required = self.instance_method(:calculate).parameters.select { |arg| arg[0] == :keyreq }
    required.map { |arg| arg[1] }
  end

  protected
  def self.endpoint(name)
    @endpoint = name.downcase
  end
end
