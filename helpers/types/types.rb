def get_field(context, field_name)
  context.send(CalculatorLoaderContext::FIELD_PREFIX + field_name.to_sym)
end

def get_field_as_bool(context, field_name)
  value = get_field context, field_name

  if value.bool?
    value.to_bool
  else
    fail FieldError.new field_name.to_s, 'must be a boolean (true/false)'
  end
end

def get_field_as_float(context, field_name)
  value = get_field context, field_name

  if value.float?
    Float(value)
  else
    fail FieldError.new field_name.to_s, 'must be a float'
  end
end

def get_field_as_integer(context, field_name)
  value = get_field context, field_name

  if value.integer?
    Integer(value)
  else
    fail FieldError.new field_name.to_s, 'must be an integer'
  end
end

def get_field_as_sex(context, field_name)
  value = get_field context, field_name

  return :male   if value =~ (/^(m|male|0)$/i)
  return :female if value =~ (/^(f|female|1)$/i)

  fail FieldError.new field_name.to_s, 'must be a sex (male/female)'
end

def get_fields_as_date(context, day_field, month_field, year_field)
  day_value = get_field_as_integer context, day_field
  month_value = get_field_as_integer context, month_field
  year_value = get_field_as_integer context, year_field

  begin
    Date.new year_value, month_value, day_value
  rescue ArgumentError
    fail FieldError.new [ day_field, month_field, year_field ], 'invalid date'
  end
end

add_helper_method method(:get_field_as_bool)
add_helper_method method(:get_field_as_float)
add_helper_method method(:get_field_as_integer)
add_helper_method method(:get_field_as_sex)
add_helper_method method(:get_fields_as_date)
