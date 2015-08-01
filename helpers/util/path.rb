def resolve_path(context, filename, file, required = false)
  path = File.expand_path(filename, File.dirname(file))

  if required && !File.exists?(path)
    raise ServerError.new("missing #{filename}")
  end

  path
end
