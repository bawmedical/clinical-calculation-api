require_relative './logging.rb'

class HelperContext
  include Logging

  def initialize
    @helpers = {}
  end

  def helpers
    @helpers
  end

  def add_helper_module(helper_module)
    instance = Class.new.extend(helper_module)

    helper_module.instance_methods.each do |helper_name|
      add_helper_method instance.method(helper_name)
    end
  end

  def add_helper_method(helper_method)
    helpers[helper_method.name] = helper_method
  end
end
