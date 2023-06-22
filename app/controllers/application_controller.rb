class ApplicationController < ActionController::Base
  before_action :cookie_banner, :set_tracking_code, :ensure_session_last_seen, :set_no_back_link_pages
  after_action :update_session_last_seen

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASS")
  end

private

  def set_no_back_link_pages
    @no_back_link_pages = ["/", "/expression-of-interest/confirm", "/sponsor-a-child/task-list", "sponsor-a-child/cancel_confirm", "/sponsor-a-child/cancel-application", "/sponsor-a-child/check-answers", "/sponsor-a-child/confirm", "/sponsor-a-child/save-and-return/confirm", "/sponsor-a-child/save-and-return/resend-link", "/cookies"]
  end

  def set_tracking_code
    Rails.logger.debug request.fullpath

    if cookies[:cookies_preferences_set].present? && cookies[:cookies_preferences_set] == "true" && cookies[:cookies_policy].present?
      if request.fullpath.include?("child") && ENV["UAM_GA4_TRACKING_CODE"].present?
        session[:ga4_tracking_code] = ENV.fetch("UAM_GA4_TRACKING_CODE")
      elsif request.fullpath.include?("expression") && ENV["EOI_GA4_TRACKING_CODE"].present?
        session[:ga4_tracking_code] = ENV.fetch("EOI_GA4_TRACKING_CODE")
      end
    else
      session[:ga4_tracking_code] = "X-XXXX-XXXX"
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

  def cookie_banner
    if cookies[:cookies_preferences_set].present? && cookies[:cookies_preferences_set] == "true" && cookies[:cookies_policy].present?
      cookies_json = JSON.parse(cookies[:cookies_policy])
      @cookies_accepted = cookies_json["analytics"]
    end
  end
end
