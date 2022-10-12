class ApplicationController < ActionController::Base
  before_action :set_tracking_code, :ensure_session_last_seen
  after_action :update_session_last_seen

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASS")
  end

private

  def set_tracking_code
    Rails.logger.debug request.fullpath
    if request.fullpath.include?("child") && ENV.fetch("UAM_GA_TRACKING_CODE").present?
      GA.tracker = ENV.fetch("UAM_GA_TRACKING_CODE")
    end
    if request.fullpath.include?("individual") && ENV.fetch("EOI_GA_TRACKING_CODE").present?
      GA.tracker = ENV.fetch("EOI_GA_TRACKING_CODE")
    end
  end

  def ensure_session_last_seen
    if session[:last_seen].nil?
      session[:last_seen] = Time.zone.now.utc.to_s
    end
  end

  def update_session_last_seen
    session[:last_seen] = Time.zone.now.utc.to_s
  end
end
