class ApiError < StandardError
  attr_reader :code

  def initialize(code, message)
    super message

    @code = code
  end

  def to_h
    { error: code, message: message, error_type: self.class.name }
  end
end

class InvalidRequestError < ApiError
  def initialize(message = nil)
    super 400, (message || 'invalid request')
  end
end

class NotFoundError < ApiError
  def initialize(message = nil)
    super 404, (message || 'not found')
  end
end

class ServerError < ApiError
  def initialize(message = nil)
    super 500, (message || 'server error')
  end
end

class FieldError < InvalidRequestError
  attr_reader :field

  def initialize(field, message)
    super message

    @field = field
  end

  def to_h
    super.merge(error_field: field)
  end
end

class NoFieldError < FieldError
  def initialize(field, message = nil)
    super field, (message || 'missing field')
  end
end
