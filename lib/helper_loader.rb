require_relative './file_loader.rb'
require_relative './logging.rb'
require_relative './helper_context.rb'

class HelperLoader < FileLoader
  include Logging

  def initialize
    super HelperContext
  end

  def helpers
    helpers = {}

    loaded_files.values.each do |context|
      context.helpers.each do |name, helper|
        helpers[name] = helper unless helpers.include? name
      end
    end

    helpers
  end

  def helper?(name)
    helpers.include? name.to_sym
  end

  def get_helper(name)
    helper = helpers.find { |helper_name, _helper| helper_name.to_sym == name.to_sym }

    helper.last unless helper.nil?
  end
end
