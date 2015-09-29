def act_on_rule(rule_points, rule_cause, field_value)
  return rule_points if rule_points.respond_to?(:call) && rule_cause.call(field_value)
  return rule_points if rule_cause == field_value
  0
end

def get_points(rule, field_name, field_value)
  fail ServerError, "missing points from rule for field `#{field_name}'" unless rule.key? :points

  rule_points = rule[:points]
  rule_cause = rule.key?(:cause) ? rule[:cause] : true

  act_on_rule rule_points, rule_cause, field_value
end

def calculate_score(_fields, rules, fields)
  score = 0

  rules.each do |field_name, rule|
    field_value = fields[field_name]

    if rule.is_a? Array
      scores = rule.map { |r| get_points r, field_name, field_value }
      score += scores.reduce(:+)
    else
      score += get_points rule, field_name, field_value
    end
  end

  score
end

add_helper_method method(:calculate_score)
