class CalculatorRouter
  include Logging

  ERRORS = {
    invalid_request: { error: 400, message: "Invalid request" },
    not_found: { error: 404, message: "Not found" },
    server_error: { error: 500, message: "Server error" }
  }

  def initialize(loader)
    @loader = loader
  end

  def endpoint?(endpoint_name)
    !get_endpoint(endpoint_name).nil?
  end

  def get_endpoint(endpoint_name)
    @loader.get_calculators.find { |calculator| calculator.get_endpoint == endpoint_name }
  end

  def convert_to_type(value, type)
    return value if type.nil?

    case type
      when :number, :float
        return Float(value)
      when :integer
        return Integer(value)
    end

    raise
  end

  def convert_keys_to_sym(hash)
    new_hash = {}
    hash.each { |k, v| new_hash[k.to_sym] = v }
    new_hash
  end

  def get_missing_args(endpoint, data)
    endpoint.get_required_args.select { |k| !data.include? k }
  end

  def get_invalid_args(endpoint, data)
    invalid_args = data.keys.select do |k|
      begin
        convert_to_type data[k], endpoint.get_arg_type(k)

        false
      rescue => e
        true
      end
    end
  end

  def convert_data(endpoint, data)
    converted_data = {}

    data.each do |k, v|
      converted_data[k] = convert_to_type v, endpoint.get_arg_type(k)
    end

    convert_data
  end

  def handle_endpoint(endpoint_name, data)
    logger.info "Handling endpoint `#{endpoint_name}' with data `#{data}'"

    endpoint = get_endpoint endpoint_name

    return ERRORS[:not_found] if endpoint.nil?

    data = convert_keys_to_sym data

    missing_args = get_missing_args endpoint, data

    if missing_args.length > 0
      missing_arg = missing_args.first

      logger.info "Missing argument `#{missing_arg}'"

      return { error: ERRORS[:invalid_request][:error], message: "Missing argument '#{missing_arg}'", argument: missing_arg }
    end

    invalid_args = get_invalid_args endpoint, data

    if invalid_args.length > 0
      invalid_arg = invalid_args.first

      logger.info "Invalid argument `#{invalid_arg}'"

      return { error: ERRORS[:invalid_request][:error], message: "Invalid argument '#{invalid_arg}'", argument: invalid_arg}
    end

    numeric_data = {}
    data.each { |k, v| numeric_data[k] = Float(v) }

    result = endpoint.calculate **numeric_data

    return { result: result }
  end
end
