class BmiController < ApplicationController
  def calculate
    bmi = params[:weight].to_f / ( params[:height].to_f ** 2 )
    render json: {
      request_parameters: {
        height: params[:height],
        weight: params[:weight],
      },
      calculation: {
        bmi: bmi,
        units: 'kg/m^2',
        snomed_ct_id: '60621009', # 60621009 | Body mass index (observable entity) |
      },
      metadata: {
        authors: ['Dr Marcus Baw MBChB MRCGP FFCI, email: marcusbaw@gmail.com, tw: @marcus_baw'],
        clinical_assurance: '',
        publication_date: '',
      },
    }
  end
end
