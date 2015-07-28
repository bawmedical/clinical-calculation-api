class Calculator
  include Logging

  def calculate
    raise NotImplementedError
  end

  def self.get_endpoint
    @endpoint || self.name.downcase
  end

  def self.get_arg_type(name)
    return nil if @types.nil?

    @types[name] || :number
  end

  def self.get_all_args
    self.method(:calculate).parameters.map { |arg| arg[1] }
  end

  def self.get_required_args
    required = self.method(:calculate).parameters.select { |arg| arg[0] == :keyreq }
    required.map { |arg| arg[1] }
  end

  protected
  def self.endpoint(name)
    @endpoint = name.downcase
  end

  def self.arg_type(name, type)
    @types = {} if @types.nil?

    if name.kind_of? Array
      name.each { |n| @types[n] = type }
    else
      @types[name] = type
    end
  end
end
