class TestCalculator < Calculator
  def initialize
    # Set up all of your stuff here (e.g. load JSON files)
    logger.debug 'Initialized test calc'
  end

  # Endpoints are named the same as their method unless otherwise specified
  #
  # GET /first
  def my_first_endpoint
    'Hello, this is the first endpoint!'
  end

  # GET /my_second_endpoint
  def my_second_endpoint(_fields, _helpers)
    'Hello, this is the second endpoint!'
  end

  endpoint :my_first_endpoint, name: :first
  endpoint :my_second_endpoint # Name is not required
end
