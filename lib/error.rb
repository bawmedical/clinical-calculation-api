class Error
  def initialize(code, message)
    @code = code
    @message = message
  end

  def code
    @code
  end

  def message
    @message
  end

  def clone(code: nil, message: nil)
    clone_code = code.nil? ? self.code : code
    clone_message = message.nil? ? self.message : message

    self.class.new clone_code, clone_message
  end
end

module Errors
  INVALID_REQUEST = Error.new 400, "Invalid request"
  NOT_FOUND = Error.new 404, "Not found"
  SERVER_ERROR = Error.new 500, "Server error"
end
