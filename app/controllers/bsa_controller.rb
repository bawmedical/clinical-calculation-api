class BsaController < ApplicationController
  def calculate
    # Body Surface Area calculation
    bsa = ( (params[:weight].to_f * (params[:height].to_f * 100) ) / 3600)**0.5

    render json: {
      request_parameters: {
        height: params[:height],
        weight: params[:weight],
      },
      calculation: {
        body_surface_area: bsa,
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
