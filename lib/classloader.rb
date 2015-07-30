class ClassLoaderContext
  def initialize(classloader)
    @classloader = classloader
  end

  def classloader
    @classloader
  end
end

class ClassLoader
  def initialize(context = nil)
    @context = context || ClassLoaderContext
    @loaded_files = {}
  end

  def load_file(filename)
    file_module = get_file_module filename

    if file_module.nil?
      return nil
    end

    @loaded_files[filename] = file_module
  end

  def unload_file(filename)
    return nil unless @loaded_files.include? filename

    @loaded_files[filename] = nil
  end

  def loaded_files
    @loaded_files
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
