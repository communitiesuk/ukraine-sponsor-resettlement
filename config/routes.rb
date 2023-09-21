Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "redirect#redirect_homepage"

  get "sponsor-a-child", to: "unaccompanied#guidance"

  get "/health", to: proc { [200, {}, %w[OK]] }
  get "/cookies", to: "cookies#display"
  post "/cookies", to: "cookies#post"
  get "/individual", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/individual/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/individual/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/individual/check_answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/individual/check_answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/individual/confirm", to: redirect("/expression-of-interest/self-assessment/property-suitable")

  get "/organisation", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/organisation/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/organisation/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/organisation/check_answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/organisation/check_answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/organisation/confirm", to: redirect("/expression-of-interest/self-assessment/property-suitable")

  get "/additional-info/", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/ref", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/ref/:reference", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/start/:reference", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/additional-info/steps/:stage", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/check-answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/check_answers", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  post "/additional-info/submit", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/additional-info/confirm", to: redirect("/expression-of-interest/self-assessment/property-suitable")

  get "/expression-of-interest/self-assessment/property-suitable", to: "eoi#property_suitable"
  get "/expression-of-interest/self-assessment/challenges", to: "eoi#challenges"
  get "/expression-of-interest/self-assessment/can-you-commit", to: "eoi#can_you_commit"
  get "/expression-of-interest/self-assessment/your-info", to: "eoi#your_info"
  get "/expression-of-interest/self-assessment/other-ways-to-help", to: "eoi#other_ways_to_help"
  get "/expression-of-interest", to: redirect("/expression-of-interest/self-assessment/property-suitable")
  get "/expression-of-interest/steps/:stage", to: "eoi#display"
  post "/expression-of-interest/steps/:stage", to: "eoi#handle_step"
  get "/expression-of-interest/check-answers", to: "eoi#check_answers"
  post "/expression-of-interest/check-answers", to: "eoi#submit"
  get "/expression-of-interest/confirm", to: "eoi#confirm"

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
  get "/sponsor-a-child/resume-application/select", to: "token_based_resume#select_multiple_applications"
  post "/sponsor-a-child/resume-application/select", to: "token_based_resume#select_multiple_applications"
  get "/sponsor-a-child/session-expired", to: "token_based_resume#session_expired"
  get "/sponsor-a-child/save-and-return/confirm", to: "token_based_resume#save_return_confirm"
  get "/sponsor-a-child/save-and-return/resend-link", to: "token_based_resume#save_return_resend_link_form"
  get "/sponsor-a-child/save-and-return/resend-token", to: "token_based_resume#request_new_token"
  get "/sponsor-a-child/save-and-return", to: "token_based_resume#save_return"
  post "/sponsor-a-child/resend-link", to: "token_based_resume#resend_link"

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
