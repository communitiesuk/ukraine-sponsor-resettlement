Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "index#index", as: :root

  get "sponsor-a-child", to: "unaccompanied#guidance"

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

  get "/sponsor-a-child", to: "unaccompanied#guidance"
  get "/sponsor-a-child/start", to: "unaccompanied#start"
  get "/sponsor-a-child/start-application", to: "unaccompanied#start_application"
  get "/sponsor-a-child/check", to: "unaccompanied#check_if_can_use"
  get "/sponsor-a-child/steps/:stage", to: "unaccompanied#display"
  post "/sponsor-a-child/steps/:stage", to: "unaccompanied#handle_step"
  post "/sponsor-a-child/steps/:stage/:key", to: "unaccompanied#handle_step"
  get "/sponsor-a-child/task-list", to: "unaccompanied#task_list"
  get "/sponsor-a-child/non-eligible", to: "unaccompanied#non_eligible"
  get "/sponsor-a-child/steps/:stage/:key", to: "unaccompanied#display"

  post "/sponsor-a-child/save_or_cancel", to: "unaccompanied#save_or_cancel_application"
  post "/sponsor-a-child/cancel-application", to: "unaccompanied#cancel_confirm"

  get "/sponsor-a-child/check-answers", to: "unaccompanied#check_answers"
  get "/sponsor-a-child/check_answers", to: "unaccompanied#check_answers"
  post "/sponsor-a-child/check-answers", to: "unaccompanied#submit"
  get "/sponsor-a-child/confirm", to: "unaccompanied#confirm"
  get "/sponsor-a-child/upload-uk/:stage", to: "unaccompanied#display"
  get "/sponsor-a-child/upload-ukraine/:stage", to: "unaccompanied#display"
  post "/sponsor-a-child/upload-uk/:stage", to: "unaccompanied#handle_upload_uk"
  post "/sponsor-a-child/upload-ukraine/:stage", to: "unaccompanied#handle_upload_ukraine"
  get "/sponsor-a-child/remove/:key", to: "unaccompanied#remove_adult"
  get "/sponsor-a-child/remove-other-name/:given_name/:family_name", to: "unaccompanied#remove_other_sponsor_name"
  get "/sponsor-a-child/remove-other-nationality/:country_code", to: "unaccompanied#remove_other_nationality"

  get "/sponsor-a-child/resume-application", to: "token_based_resume#display"
  post "/sponsor-a-child/resume-application", to: "token_based_resume#submit"
  get "/sponsor-a-child/session-expired", to: "token_based_resume#session_expired"
  get "/sponsor-a-child/save-and-return", to: "token_based_resume#save_return"
  get "/sponsor-a-child/save-and-return-confirm", to: "token_based_resume#save_return_confirm"
  get "/sponsor-a-child/save-and-return-expired", to: "token_based_resume#save_return_expired"
  post "/sponsor-a-child/resend-link", to: "token_based_resume#resend_link"

  get "/sponsor-a-child/list", to: "s3_bucket#list_objects"
  get "/sponsor-a-child/consent_upload", to: "foundry_consent_upload#display"
  post "/sponsor-a-child/consent_upload", to: "foundry_consent_upload#form"

  get "/fraud-support", to: "fraud#display"
  post "/fraud-support", to: "fraud#post"

  get "/confirm-application", to: "sendapp#display"
  post "/confirm-application", to: "sendapp#post"

  scope via: :all do
    match "/404", to: "errors#not_found"
    match "/429", to: "errors#too_many_requests"
    match "/500", to: "errors#internal_server_error"
  end

  get "*path", to: "errors#not_found"
end
