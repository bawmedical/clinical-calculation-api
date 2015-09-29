class WellsDvtCalculator < Calculator
  SCORING = {
    # Active Cancer (Treatment or Pallation within 6 months)
    active_cancer: { points: 1 },

    # Bedridden recently >= 3 days or major surgery within 12 weeks
    bedridden_major_surgery: { points: 1 },

    # Calf swelling > 3 cm
    calf_swollen: { points: 1 },

    # Collateral superficial veins present
    collateral_veins: { points: 1 },

    # Entire leg swollen
    full_swelling: { points: 1 },

    # Localized tenderness along the deep venous system
    local_tenderness: { points: 1 },

    # Pitting edema confined to symptomatic leg
    pitting_edema: { points: 1 },

    # Paralysis, paresis, or recent plaster immobilization of the extremity
    immobilized_leg: { points: 1 },

    # Previously documented DVT
    previous_dvt: { points: 1 },

    # Alternative diagnosis to DVT at least as likely
    alternate_diagnosis: { points: -2 }
  }

  def wellsdvt(_fields, helpers)
    fields = {
      active_cancer:           helpers.get_field_as_bool(:active_cancer),
      bedridden_major_surgery: helpers.get_field_as_bool(:bedridden_major_surgery),
      calf_swollen:            helpers.get_field_as_bool(:calf_swollen),
      collateral_veins:        helpers.get_field_as_bool(:collateral_veins),
      full_swelling:           helpers.get_field_as_bool(:full_swelling),
      local_tenderness:        helpers.get_field_as_bool(:local_tenderness),
      pitting_edema:           helpers.get_field_as_bool(:pitting_edema),
      immobilized_leg:         helpers.get_field_as_bool(:immobilized_leg),
      previous_dvt:            helpers.get_field_as_bool(:previous_dvt),
      alternate_diagnosis:     helpers.get_field_as_bool(:alternate_diagnosis)
    }

    helpers.generate_response helpers.calculate_score SCORING, fields
  end
end
