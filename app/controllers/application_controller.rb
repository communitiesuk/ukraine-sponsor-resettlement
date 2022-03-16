class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  if !(Rails.env.development? || Rails.env.test?) && ENV.fetch("BASIC_AUTH_USER") && ENV.fetch("BASIC_AUTH_PASS")
    http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASS")
  end
end
