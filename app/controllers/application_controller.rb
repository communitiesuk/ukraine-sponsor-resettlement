class ApplicationController < ActionController::Base

  before_action :ensure_session_last_seen

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  if !(Rails.env.development? || Rails.env.test?) && ENV["BASIC_AUTH_USER"] && ENV["BASIC_AUTH_PASS"]
    http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASS")
  end

  private

  def ensure_session_last_seen
    if session[:last_seen].nil?
      session[:last_seen] = Time.zone.now.utc.to_s
    end
  end

end
