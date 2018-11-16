class WellsDvtController < ApplicationController
  def calculate
    # all parameters default to false
    active_cancer = params[:active_cancer] || "false"
    bedridden_major_surgery = params[:bedridden_major_surgery] || "false"
    calf_swollen = params[:calf_swollen] || "false"
    collateral_veins = params[:collateral_veins] || "false"
    full_swelling = params[:full_swelling] || "false"
    local_tenderness = params[:local_tenderness] || "false"
    pitting_oedema = params[:pitting_oedema] || "false"
    immobilised_leg = params[:immobilised_leg] || "false"
    previous_dvt = params[:previous_dvt] || "false"
    alternate_diagnosis = params[:alternate_diagnosis] || "false"

    wells_dvt_score = 0 # start scoring at zero

    # Active Cancer (Treatment or Pallation within 6 months)
    wells_dvt_score += 1 if active_cancer == "true"

    # Bedridden recently >= 3 days or maj surgery within 12 weeks
    wells_dvt_score += 1 if bedridden_major_surgery == "true"

    # Calf swelling > 3 cm
    wells_dvt_score += 1 if calf_swollen == "true"

    # Collateral superficial veins present
    wells_dvt_score += 1 if collateral_veins == "true"

    # Entire leg swollen
    wells_dvt_score += 1 if full_swelling == "true"

    # Localized tenderness along the deep venous system
    wells_dvt_score += 1 if local_tenderness == "true"

    # Pitting oedema confined to symptomatic leg
    wells_dvt_score += 1 if pitting_oedema == "true"

    # Paralysis, paresis, or recent plaster immobilisation of the extremity
    wells_dvt_score += 1 if immobilised_leg == "true"

    # Previously documented DVT
    wells_dvt_score += 1 if previous_dvt == "true"

    # Alternative diagnosis to DVT at least as likely
    wells_dvt_score -= 2 if alternate_diagnosis == "true"

    render json: {
      request_parameters: {
        active_cancer: active_cancer,
        bedridden_major_surgery: bedridden_major_surgery,
        calf_swollen: calf_swollen,
        collateral_veins: collateral_veins,
        full_swelling: full_swelling,
        local_tenderness: local_tenderness,
        pitting_oedema: pitting_oedema,
        immobilised_leg: immobilised_leg,
        previous_dvt: previous_dvt,
        alternate_diagnosis: alternate_diagnosis,
      },
      calculation: {
        wells_dvt_score: wells_dvt_score,
        units: 'unitless arbitrary clinical risk scale',
        snomed_ct_id: '429053008', # | Wells deep vein thrombosis clinical probability score (observable entity) |
      },
      metadata: {
        authors: '',
        clinical_assurance: '',
        publication_date: '',
      },
    }
  end
end
