class FileLoader
  attr_reader :loaded_files
  attr_reader :wrapper
  attr_reader :wrapper_args

  def initialize(wrapper = Module, wrapper_args = nil)
    @loaded_files = {}
    @wrapper = wrapper
    @wrapper_args = wrapper_args
  end

  def load_file(filename)
    @loaded_files[filename] = get_file_module(filename)
  end

  def load_directory(directory, only_subdirectories = true)
    glob = only_subdirectories ? '*' : '*.rb'

    Dir.glob(File.join(directory, glob)).each do |basename|
      if File.directory?(basename) && only_subdirectories
        load_directory basename, false
      elsif !only_subdirectories
        load_file basename
      end
    end
  end

  def values
    loaded_files.values.reduce :concat
  end

  private

  def get_wrapper_instance
    if wrapper_args.is_a? Array
      wrapper.new *wrapper_args
    elsif wrapper_args.is_a? Hash
      wrapper.new **wrapper_args
    else
      wrapper.new
    end
  end

  def get_file_module(filename)
    mod = get_wrapper_instance

    return nil if mod.nil?

    source = File.read(filename)

    if mod.respond_to? :module_eval
      mod.module_eval source, filename
    else
      mod.instance_eval source, filename
    end

    mod
  end
end
