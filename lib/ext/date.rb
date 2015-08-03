require 'date'

class Date
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def self.days_in_month(year, month)
    return 29 if month == 2 && gregorian_leap?(year)
    COMMON_YEAR_DAYS_IN_MONTH[month]
  end

  def self.valid_day?(year, month, day)
    days = days_in_month year, month

    return false if days.nil?
    (1..days).include? day
  end

  def self.valid_month?(month)
    (1..12).include? month
  end

  def days_in_month
    self.class.days_in_month year, month
  end
end
