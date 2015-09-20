require 'json'

def resolve_path(_fields, filename, file, required = false)
  path = File.expand_path(filename, File.dirname(file))

  fail ServerError, "missing #{filename}" if required && !File.exist?(path)

  path
end

def read_file(fields, filename, file)
  File.read resolve_path(fields, filename, file, true)
end

def read_json(fields, filename, file)
  JSON.parse read_file(fields, filename, file)
end

add_helper_method method(:resolve_path)
add_helper_method method(:read_file)
add_helper_method method(:read_json)
