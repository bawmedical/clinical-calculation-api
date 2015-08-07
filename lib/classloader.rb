class ClassLoader
  attr_reader :loaded_files

  def initialize
    @loaded_files = {}
  end

  def load(filename)
    @loaded_files[filename] = get_file_module(filename).classes
  end

  def classes
    loaded_files.values.reduce :concat
  end

  private

  def get_file_module(filename)
    mod = Module.new
    mod.module_eval File.read(filename), filename

    mod
  end
end
