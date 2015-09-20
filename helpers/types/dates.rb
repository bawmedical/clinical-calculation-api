def months_between(_fields, start_date, end_date)
  ((start_date - end_date).abs / (365.25 / 12)).round
end

add_helper_method method(:months_between)
