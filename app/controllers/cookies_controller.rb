class CookiesController < ApplicationController
  add_flash_types :error

  def display
    @abstractcookies = AbstractCookiesAccept.new
    @back_to_link = params["back_to"] || (request.referer.present? ? URI(request.referer).path : "/")
    render "cookies/cookies"
  end

  def post
    @abstractcookies = AbstractCookiesAccept.new
    @abstractcookies.assign_attributes(confirm_params)
    Rails.logger.debug 'fuck you'
    session[:cookies_accepted] = @abstractcookies.cookies_accepted.casecmp("yes").zero?.to_s
    @cookies_accepted = @abstractcookies.cookies_accepted.casecmp("yes").zero?
    cookies[:cookies_preferences_set] = { value: "true", expires: 1.year.from_now }
    @cookies_updated = true

    display
  end

private

  def confirm_params
    params.require(:abstract_cookies_accept).permit(:cookies_accepted)
  end
end
