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

class NoFieldError < InvalidRequestError
  def initialize(field, message = nil)
    super (message || "Missing field '#{field}'")

    @field = field
  end

  def field
    @field
  end

  def to_h
    super.merge({ field: field })
  end
end
