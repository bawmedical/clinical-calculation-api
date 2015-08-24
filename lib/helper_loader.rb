require_relative "./class_loader.rb"
require_relative "./logging.rb"

class HelperLoaderContext < ClassLoaderContext
  include Logging

  def initialize(classloader)
    super classloader

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

class HelperLoader < ClassLoader
  include Logging

  HELPER_EXT = ".rb"

  def initialize
    super HelperLoaderContext
  end

  def load_directory(directory)
    logger.debug "Loading directory `#{directory}'"

    Dir.glob(File.join(directory, "*#{HELPER_EXT}")).each { |filename| load_file filename }
  end

  def load_helpers(directory)
    logger.debug "Loading helpers from `#{directory}'"

    Dir.glob(File.join(directory, "*")).each do |filename|
      if File.directory? filename
        load_directory filename
      end
    end
  end

  def load_file(filename)
    all_helpers = helpers

    loaded_file = super filename

    if loaded_file.nil?
      logger.warn "Failed to load `#{filename}'"
    else
      duplicate_helper = nil

      loaded_file.helpers.keys.each do |name|
        if all_helpers.include? name
          duplicate_helper = name
          break
        end
      end

      if !duplicate_helper.nil?
        logger.error "Helper `#{duplicate_helper}' (found in `#{filename}') already defined"
        return nil
      else
        loaded_count = loaded_file.helpers.keys.length
        logger.debug "Loaded #{loaded_count} helper #{"method".pluralize loaded_count, "s"} from `#{filename}'"
      end
    end

    loaded_file
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
