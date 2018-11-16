Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/v1', defaults: { format: :json } do
    # clinical calculation api endpoints, in alphabetical order
    get 'bmi', to: 'bmi#calculate'
    get 'bsa', to: 'bsa#calculate'
    get 'chads2vasc', to: 'chads2vasc#calculate'
    get 'dummy_data', to: 'dummy_data#calculate'
    get 'wells_dvt', to: 'wells_dvt#calculate'
  end

end
