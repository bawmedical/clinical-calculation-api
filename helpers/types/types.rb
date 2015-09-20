def get_field(fields, field_name)
  fields.send(field_name)
end

def get_field_as_bool(fields, field_name)
  value = get_field fields, field_name

  if value.bool?
    value.to_bool
  else
    fail FieldError.new field_name.to_s, 'must be a boolean (true/false)'
  end
end

def get_field_as_float(fields, field_name)
  value = get_field fields, field_name

  if value.float?
    Float(value)
  else
    fail FieldError.new field_name.to_s, 'must be a float'
  end
end

def get_field_as_integer(fields, field_name)
  value = get_field fields, field_name

  if value.integer?
    Integer(value)
  else
    fail FieldError.new field_name.to_s, 'must be an integer'
  end
end

def get_field_as_sex(fields, field_name)
  value = get_field fields, field_name

  return :male   if value =~ (/^(m|male|0)$/i)
  return :female if value =~ (/^(f|female|1)$/i)

  fail FieldError.new field_name.to_s, 'must be a sex (male/female)'
end

def get_fields_as_date(fields, year_field, month_field, day_field)
  year_value = get_field_as_integer fields, year_field
  month_value = get_field_as_integer fields, month_field
  day_value = get_field_as_integer fields, day_field

  valid_year = year_value > 0
  valid_month = Date.valid_month? month_value
  days_in_month = Date.days_in_month year_value, month_value
  valid_day = Date.valid_day? year_value, month_value, day_value

  fail FieldError.new year_field, 'must be greater than zero' unless valid_year
  fail FieldError.new month_field, 'must be in the range 1 to 12' unless valid_month
  fail FieldError.new day_field, "must be in the range 1 to #{days_in_month}" unless valid_day

  begin
    Date.new year_value, month_value, day_value
  rescue ArgumentError
    raise InternalServerError, 'invalid date'
  end
end

def try_field
  yield
rescue NoFieldError
  nil
end

add_helper_method method(:get_field_as_bool)
add_helper_method method(:get_field_as_float)
add_helper_method method(:get_field_as_integer)
add_helper_method method(:get_field_as_sex)
add_helper_method method(:get_fields_as_date)
add_helper_method method(:get_field)
add_helper_method method(:try_field)
