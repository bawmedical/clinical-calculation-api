require_relative './file_loader.rb'
require_relative './logging.rb'
require_relative './helper_context.rb'

class HelperLoader < FileLoader
  include Logging

  attr_reader :helpers

  def initialize
    super HelperContext
    @helpers = {}
  end

  def load_file(filename)
    loaded_file = super

    if loaded_file.nil?
      logger.error "Failed to load `#{filename}'"
    else
      @helpers.merge loaded_file.helpers
    end
  end

  def helper?(name)
    helpers.include? name.to_sym
  end

  def get_helper(name)
    helpers[name]
  end
end
