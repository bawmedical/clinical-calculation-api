def get_field(context, field_name)
  context.send(CalculatorLoaderContext::FIELD_PREFIX + field_name.to_sym)
end

def get_field_as_bool(context, field_name)
  value = get_field context, field_name

  begin
    value.to_s.to_bool
  rescue ArgumentError
    raise FieldError.new field_name.to_s, "must be a boolean (true/false)"
  end
end

def get_field_as_float(context, field_name)
  value = get_field context, field_name

  if value.is_float?
    Float(value)
  else
    raise FieldError.new field_name.to_s, "must be a float"
  end
end

def get_field_as_integer(context, field_name)
  value = get_field context, field_name

  if value.is_integer?
    Integer(value)
  else
    raise FieldError.new field_name.to_s, "must be an integer"
  end
end

def get_field_as_sex(context, field_name, sex_male = :male, sex_female = :female)
  value = get_field context, field_name

  return sex_male   if value =~ (/^(m|male|0)$/i)
  return sex_female if value =~ (/^(f|female|1)$/i)

  raise FieldError.new field_name.to_s, "must be a sex (male/female)"
end

add_helper_method method(:get_field_as_bool)
add_helper_method method(:get_field_as_float)
add_helper_method method(:get_field_as_integer)
add_helper_method method(:get_field_as_sex)
