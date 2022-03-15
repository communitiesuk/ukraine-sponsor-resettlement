Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "index#index", as: :root

  get "/health", to: proc { [200, {}, [nil]] }

  get "/individual", to: redirect("/individual/steps/1")
  get "/individual/steps/:stage", to: "individual#display"
  post "/individual/steps/:stage", to: "individual#handle_step"
  get "/individual/check_answers", to: "individual#check_answers"
  post "/individual", to: "individual#submit"
  get "/individual/confirm", to: "individual#confirm"

  get "/organisation", to: redirect("/organisation/steps/1")
  get "/organisation/steps/:stage", to: "organisation#display"
  post "/organisation/steps/:stage", to: "organisation#handle_step"
  get "/organisation/check_answers", to: "organisation#check_answers"
  post "/organisation", to: "organisation#submit"
  get "/organisation/confirm", to: "organisation#confirm"

  scope via: :all do
    match "/404", to: "errors#not_found"
    match "/429", to: "errors#too_many_requests"
    match "/500", to: "errors#internal_server_error"
  end
end
