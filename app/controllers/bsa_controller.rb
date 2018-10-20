class BsaController < ApplicationController
  def calculate
    bsa = ( (params[:weight].to_f * (params[:height].to_f * 100) ) / 3600)**0.5
    render json: {
      request_parameters: {
        height: params[:height],
        weight: params[:weight],
      },
      calculation: {
        bsa: bsa,
        units: 'm^2',
      },
      metadata: {
        authors: '',
        clinical_assurance: '',
        publication_date: '',
      },
    }
  end
end
