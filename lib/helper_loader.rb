require_relative "./file_loader.rb"
require_relative "./logging.rb"

class HelperLoaderContext
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

class HelperLoader < FileLoader
  include Logging

  def initialize
    super HelperLoaderContext
  end

  def helpers
    helpers = {}

    loaded_files.values.each do |context|
      context.helpers.each do |name, helper|
        helpers[name] = helper if !helpers.include? name
      end
    end

    helpers
  end

  def has_helper?(name)
    helpers.include? name.to_sym
  end

  def get_helper(name)
    helper = helpers.find { |helper_name, helper| helper_name.to_sym == name.to_sym }

    helper.last unless helper.nil?
  end
end
