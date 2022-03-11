Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "index#index"

  get "/health", to: ->(_) { [204, {}, [nil]] }

  get "/form", to: "form#display"
end
