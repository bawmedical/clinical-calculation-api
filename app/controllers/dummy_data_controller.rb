class DummyDataController < ApplicationController
  # This controller makes plausible-ish dummy data for a given condition
  # the condition is specified by SNOMED-CT code in the request
  #

  def calculate
    case params[:clinical_code]

    when '44054006'
      # 44054006 | Diabetes mellitus type 2 (disorder) |
      rbg = dummy_normal_distribution(
        params[:rbg_mean] || 7.60,
        params[:rbg_standard_deviation] || 1.17,
        params[:rbg_number_in_series] || 10,
      )
      hba1c = dummy_normal_distribution(
        params[:hba1c_mean] || 59,
        params[:hba1c_standard_deviation] || 15.14,
        params[:hba1c_number_in_series] || 3,
      )
    else
      message = "No dummy data available for clinical code #{params[:clinical_code]}"
    end

    render json: {
          request_parameters: params,
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

  def dummy_normal_distribution(mean, standard_deviation, number_in_series)
    normal = Distribution::Normal.rng(mean.to_f, standard_deviation.to_f)
    number_in_series.to_i.times.map { normal.call.round(1) }
  end

end
