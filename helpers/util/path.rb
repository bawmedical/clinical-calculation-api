def resolve_path(_context, filename, file, required = false)
  path = File.expand_path(filename, File.dirname(file))

  fail ServerError, "missing #{filename}" if required && !File.exist?(path)

  path
end

add_helper_method method(:resolve_path)
