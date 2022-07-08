Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "index#index", as: :root

  get "/health", to: proc { [200, {}, %w[OK]] }

  get "/individual", to: redirect("/individual/steps/1")
  get "/individual/steps/:stage", to: "individual#display"
  post "/individual/steps/:stage", to: "individual#handle_step"
  get "/individual/check_answers", to: "individual#check_answers"
  post "/individual/check_answers", to: "individual#submit"
  get "/individual/confirm", to: "individual#confirm"

  get "/organisation", to: redirect("/organisation/steps/1")
  get "/organisation/steps/:stage", to: "organisation#display"
  post "/organisation/steps/:stage", to: "organisation#handle_step"
  get "/organisation/check_answers", to: "organisation#check_answers"
  post "/organisation/check_answers", to: "organisation#submit"
  get "/organisation/confirm", to: "organisation#confirm"

  get "/additional-info/", to: "errors#reference_not_found"
  get "/additional-info/ref", to: "errors#reference_not_found"
  get "/additional-info/ref/:reference", to: "additional#home"
  get "/additional-info/start/:reference", to: "additional#start"
  get "/additional-info/steps/:stage", to: "additional#display"
  post "/additional-info/steps/:stage", to: "additional#handle_step"
  get "/additional-info/check-answers", to: "additional#check_answers"
  get "/additional-info/check_answers", to: "additional#check_answers"
  post "/additional-info/submit", to: "additional#submit"
  get "/additional-info/confirm", to: "additional#confirm"

  get "/unaccompanied-minor", to: "unaccompanied#guidance"
  get "/unaccompanied-minor/start", to: "unaccompanied#start"
  get "/unaccompanied-minor/check", to: "unaccompanied#check_if_can_use"
  get "/unaccompanied-minor/steps/:stage", to: "unaccompanied#display"
  post "/unaccompanied-minor/steps/:stage", to: "unaccompanied#handle_step"
  get "/unaccompanied-minor/check-answers", to: "unaccompanied#check_answers"
  get "/unaccompanied-minor/check_answers", to: "unaccompanied#check_answers"
  post "/unaccompanied-minor/check-answers", to: "unaccompanied#submit"
  get "/unaccompanied-minor/confirm", to: "unaccompanied#confirm"
  get "/unaccompanied-minor/upload-uk/:stage", to: "unaccompanied#display"
  get "/unaccompanied-minor/upload-ukraine/:stage", to: "unaccompanied#display"
  post "/unaccompanied-minor/upload-uk/:stage", to: "unaccompanied#handle_upload_uk"
  post "/unaccompanied-minor/upload-ukraine/:stage", to: "unaccompanied#handle_upload_ukraine"

  get "/unaccompanied-minor/task-list", to: "unaccompanied#task_list"

  scope via: :all do
    match "/404", to: "errors#not_found"
    match "/429", to: "errors#too_many_requests"
    match "/500", to: "errors#internal_server_error"
  end

  get "*path", to: "errors#not_found"
end
