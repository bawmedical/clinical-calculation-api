class ClassLoaderContext
  attr_reader :classloader

  def initialize(classloader)
    @classloader = classloader
  end
end

class ClassLoader
  attr_reader :loaded_files

  def initialize(context = nil)
    @context = context || ClassLoaderContext
    @loaded_files = {}
  end

  def load_file(filename)
    file_module = get_file_module filename

    return nil if file_module.nil?

    @loaded_files[filename] = file_module
  end

  def unload_file(filename)
    return nil unless @loaded_files.include? filename

    @loaded_files[filename] = nil
  end

  private

  def get_module(filename, source)
    mod = @context.new self
    mod.instance_eval source, filename

    mod
  end

  def get_file_module(filename)
    source = File.read filename
    get_module filename, source
  end
end
