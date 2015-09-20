require_relative './error.rb'

class DynHash < Hash
  def method_missing(name, *_args, &_block)
    if key? name
      name
    else
      super
    end
  end

  def respond_to?(name, _include_private = false)
    key?(name) || super
  end
end
