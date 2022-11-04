class ApplicationController < ActionController::Base
  before_action :cookie_banner, :set_tracking_code, :ensure_session_last_seen
  after_action :update_session_last_seen

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASS")
  end

private

  def set_tracking_code
    Rails.logger.debug request.fullpath

    if request.fullpath.include?("child") && ENV["UAM_GA_TRACKING_CODE"].present? && session[:cookies_accepted].present? && session[:cookies_accepted].casecmp("true").zero? 
      GA.tracker = ENV.fetch("UAM_GA_TRACKING_CODE") 
    elsif request.fullpath.include?("expression") && ENV["EOI_GA_TRACKING_CODE"].present? &&  session[:cookies_accepted].present? && session[:cookies_accepted].casecmp("true").zero?
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
    if params[:cookies_accepted].present?
      session[:cookies_accepted] = params[:cookies_accepted]
    end
    if session[:cookies_accepted].present?
      @cookie_accepted = session[:cookies_accepted].casecmp("true").zero?
    end
    if params[:cookies_accepted].present? && params[:cookie_message_hidden].present?
      session[:cookie_message_hidden] = params[:cookie_message_hidden]
    end
    if session[:cookie_message_hidden].present?
      @cookie_message_hidden = session[:cookie_message_hidden]
    end

  end
end
