def get_bool(name)
  value = send "field_#{name}"

  begin
    value.to_s.to_bool
  rescue ArgumentError
    raise InvalidRequestError, "#{name} must be a boolean (1/0)"
  end
end

name :wellsdvt

execute do
  ## Boolean checks for Wells' DVT Criteria
  # Active Cancer (Treatment or Pallation within 6 months)
  # Bedridden recently >= 3 days or maj surgery within 12 weeks
  # Calf swelling > 3 cm

  active_cancer = get_bool("act_canc")
  bedridden_major_surgery = get_bool("bedridden_maj_surgery")
  calf_swollen = get_bool("calf_swollen")
  collateral_veins = get_bool("collat_veins")
  full_swelling = get_bool("full_swelling")
  local_tenderness = get_bool("local_tender")
  pitting_edema = get_bool("pitting_edema")
  immobilized_leg = get_bool("immobilized")
  previous_dvt = get_bool("prev_dvt")
  alternate_diagnosis = get_bool("alt_diagnosis")

  #raise InvalidRequestError, "act_canc must be a boolean (true / false)",if !field_act_canc.to_bool
  #raise InvalidRequestError, "bedridden_maj_surgery must be a boolean (true / false)" if !field_bedridden_maj_surgery.to_bool
  #raise InvalidRequestError, "calf_swollen must be a boolean (true / false)" if !field_calf_swollen.to_bool
  #raise InvalidRequestError, "collat_veins must be a boolean (true / false)" if !field_collat_veins.to_bool
  #raise InvalidRequestError, "full_swelling must be a boolean (true / false)" if !field_full_swelling.to_bool
  #raise InvalidRequestError, "local_tender must be a boolean (true / false)" if !field_local_tender.to_bool
  #raise InvalidRequestError, "pitting_edema must be a boolean (true / false)" if !field_pitting_edema.to_bool
  #raise InvalidRequestError, "immobilized must be a boolean (true / false)" if !field_immobilized.to_bool
  #raise InvalidRequestError, "prev_dvt must be a boolean (true / false)" if !field_prev_dvt.to_bool
  #raise InvalidRequestError, "alt_diagnosis must be a boolean (true / false)" if !field_alt_diagnosis.to_bool

  score = 0
  score += 1 if active_cancer
  score += 1 if bedridden_major_surgery
  score += 1 if calf_swollen
  score += 1 if collateral_veins
  score += 1 if full_swelling
  score += 1 if local_tenderness
  score += 1 if pitting_edema
  score += 1 if immobilized_leg
  score -= 2 if alternate_diagnosis

  return score
end