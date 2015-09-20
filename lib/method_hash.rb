require_relative './dyn_hash.rb'
require_relative './error.rb'

class MethodHash < DynHash
  def method_missing(name, *args, &block)
    if key? name
      self[name].call(*args, &block)
    else
      super
    end
  end
end
