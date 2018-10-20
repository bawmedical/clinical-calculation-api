class Chads2vascController < ApplicationController
  def calculate
    age = params[:age].to_f
    sex = params[:sex]
    congestive_heart_failure_history = params[:congestive_heart_failure_history]
    hypertension_history = params[:hypertension_history]
    stroke_history = params[:stroke_history]
    vascular_disease_history = params[:vascular_disease_history]
    diabetes = params[:diabetes]

    chads2vasc_score = 0

    # Age
    chads2vasc_score += 1 if (65..74).include? age
    chads2vasc_score += 2 if age >= 75

    # Sex
    chads2vasc_score += 1 if sex == :female

    # Congestive Heart Failure History
    chads2vasc_score += 1 if congestive_heart_failure_history

    # Hypertension History
    chads2vasc_score += 1 if hypertension_history

    # Stroke/TIA/Thromboembolism History
    chads2vasc_score += 2 if stroke_history

    # Vascular Disease History
    chads2vasc_score += 1 if vascular_disease_history

    # Diabetes Mellitus
    chads2vasc_score += 1 if diabetes

    render json: {
      request_parameters: {
        age: age,
        sex: sex,
        congestive_heart_failure_history: congestive_heart_failure_history,
        hypertension_history: hypertension_history,
        stroke_history: stroke_history,
        vascular_disease_history: vascular_disease_history,
        diabetes: diabetes,
      },
      calculation: {
        chads2vasc_score: chads2vasc_score,
        units: 'CHADS2VASC has no SI unit, it is an arbitrary clinical risk scale',
      },
      metadata: {
        authors: '',
        clinical_assurance: '',
        publication_date: '',
      },
    }
  end
end
