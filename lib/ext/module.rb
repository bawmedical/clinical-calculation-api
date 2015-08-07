class Module
  def classes(inherited = true)
    classes = constants.map do |name|
      value = const_get name

      if value.is_a? Class
        value
      else
        nil
      end
    end

    classes.compact
  end
end
