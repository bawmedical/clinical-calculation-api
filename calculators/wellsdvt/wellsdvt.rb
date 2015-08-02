name :wellsdvt
require_helpers :get_field_as_bool

execute do
  ## Boolean checks for Wells' DVT Criteria

  active_cancer = get_field_as_bool :active_cancer
  bedridden_major_surgery = get_field_as_bool :bedridden_major_surgery
  calf_swollen = get_field_as_bool :calf_swollen
  collateral_veins = get_field_as_bool :collateral_veins
  full_swelling = get_field_as_bool :full_swelling
  local_tenderness = get_field_as_bool :local_tenderness
  pitting_edema = get_field_as_bool :pitting_edema
  immobilized_leg = get_field_as_bool :immobilized_leg
  previous_dvt = get_field_as_bool :previous_dvt
  alternate_diagnosis = get_field_as_bool :alternate_diagnosis

  score = 0
  # Active Cancer (Treatment or Pallation within 6 months)
  score += 1 if active_cancer
  # Bedridden recently >= 3 days or maj surgery within 12 weeks
  score += 1 if bedridden_major_surgery
  # Calf swelling > 3 cm
  score += 1 if calf_swollen
  # Collateral superficial veins present
  score += 1 if collateral_veins
  # Entire leg swollen
  score += 1 if full_swelling
  # Localized tenderness along the deep venous system
  score += 1 if local_tenderness
  # Pitting edema confined to symptomatic leg
  score += 1 if pitting_edema
  # Paralysis, paresis, or recent plaster immobilization of the extremity
  score += 1 if immobilized_leg
  # Previously documented DVT
  score += 1 if previous_dvt
  # Alternative diagnosis to DVT at least as likely
  score -= 2 if alternate_diagnosis

  {
    value: score
  }
end
