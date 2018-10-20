class TemplateController < ApplicationController
  def calculate
    render json: {
      request_parameters: {
      },
      calculation: {
        units: ''
      },
      metadata: {
        authors: '',
        clinical_assurance: '',
        publication_date: '',
      },
    }
  end
end
