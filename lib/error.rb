class ApiError < StandardError
  def initialize(code, message)
    super message

    @code = code
  end

  def code
    @code
  end

  def to_h
    { error: code, message: message }
  end
end

class InvalidRequestError < ApiError
  def initialize(message = nil)
    super 400, (message || "Invalid request")
  end
end

class NotFoundError < ApiError
  def initialize(message = nil)
    super 404, (message || "Not found")
  end
end

class ServerError < ApiError
  def initialize(message = nil)
    super 500, (message || "Server error")
  end
end

class FieldError < InvalidRequestError
  def initialize(field, message)
    super message

    @field = field
  end

  def field
    @field
  end

  def to_h
    super.merge({ error_field: field })
  end
end

class NoFieldError < FieldError
  def initialize(field, message = nil)
    super field, (message || "Missing field `#{field}'")
  end
end
