class DummyDataController < ApplicationController
  # This controller makes plausible-ish dummy data for a given condition
  # the condition is specified by SNOMED-CT code in the request
  #

  def calculate
    case params[:clinical_code]

    when '44054006'
      # 44054006 | Diabetes mellitus type 2 (disorder) |
      rbg = dummy_glucose
      hba1c = '67'
    else
      message = "No dummy data available for clinical code #{params[:clinical_code]}"
    end

    render json: {
          request_parameters: {
            clinical_code: params[:clinical_code]
          },
          calculations: [
            {
              random_blood_glucose: rbg,
              units: 'mmol/l',
            },
            {
              hba1c: hba1c,
              units: 'mmol/mol (IFCC)',
            },
            message,
          ],
          metadata: {
            authors: 'Dr Marcus Baw',
            clinical_assurance: 'Not clinically assured - not for live use',
            publication_date: '2018-11-07T13:07:21+0000',
            version: '0.0.1',
          },
        }
  end

  def dummy_glucose(mean=10, sd=2.5, number_in_series=10)
    normal = Distribution::Normal.rng(mean, sd)
    number_in_series.times.map { normal.call.round(1) }
  end

end
