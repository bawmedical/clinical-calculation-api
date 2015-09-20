require_relative './dyn_hash.rb'
require_relative './error.rb'

class FieldHash < DynHash
  def method_missing(name, *_args, &_block)
    if key? name
      self[name]
    else
      fail NoFieldError, name
    end
  end
end
