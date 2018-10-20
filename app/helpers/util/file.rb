require 'json'

def resolve_path(_context, filename, file, required = false)
  path = File.expand_path(filename, File.dirname(file))

  fail ServerError, "missing #{filename}" if required && !File.exist?(path)

  path
end

def read_file(context, filename, file)
  File.read resolve_path(context, filename, file, true)
end

def read_json(context, filename, file)
  JSON.parse read_file(context, filename, file)
end

add_helper_method method(:resolve_path)
add_helper_method method(:read_file)
add_helper_method method(:read_json)
