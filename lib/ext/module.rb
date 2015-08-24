class Module
  def classes(inherited = true)
    classes = constants(inherited).map do |name|
      value = const_get name

      value if value.is_a? Class
    end

    classes.compact
  end
end
