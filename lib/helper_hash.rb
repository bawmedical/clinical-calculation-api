require_relative './method_hash.rb'

class HelperHash < MethodHash
  attr_accessor :fields

  def method_missing(name, *args, &block)
    if key? name
      if fields.nil?
        self[name].call(*args, &block)
      else
        self[name].call(fields, *args, &block)
      end
    else
      super
    end
  end
end
