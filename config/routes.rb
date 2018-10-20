Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api', defaults: { format: :json } do
    get 'example', to: 'example#calculate'
    get 'bmi', to: 'bmi#calculate'
    get 'bsa', to: 'bsa#calculate'
  end

end
