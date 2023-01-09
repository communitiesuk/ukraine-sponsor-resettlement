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

    if request.fullpath.include?("child") && ENV["UAM_GA_TRACKING_CODE"].present? && session[:cookies_accepted].present? && session[:cookies_accepted].casecmp("true").zero?
      GA.tracker = ENV.fetch("UAM_GA_TRACKING_CODE")
    elsif request.fullpath.include?("expression") && ENV["EOI_GA_TRACKING_CODE"].present? && session[:cookies_accepted].present? && session[:cookies_accepted].casecmp("true").zero?
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

  def cookie_banner
    if cookies[:cookies_preferences_set].present? && cookies[:cookies_preferences_set] == "true" && cookies[:cookies_policy].present?
      cookies_json = JSON.parse(cookies[:cookies_policy])
      @cookies_accepted = cookies_json["analytics"]
    end
  end
end
