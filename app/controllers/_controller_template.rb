class TemplateController < ApplicationController
  def calculate

    # calculation logic goes here
    # request parameters are available in the params[] array, keyed by :symbol
    # eg params[:sex] would return "M" if it had been sent in the HTTP query <baseurl>/api/v1/template?sex="M"

    render json: {
      request_parameters: {
        # send the parameters from the original request back to aid debugging
      },
      calculations: [
        {
          calculation_name: '',
          units: ''
        },
        {
          calculation_name: '',
          units: ''
        },
      ],
      metadata: {
        authors: [''], # free text names for now
        clinical_assurance: [''],
        publication_date: '', #ISO8601
        version: '',
      },
    }
  end
end
