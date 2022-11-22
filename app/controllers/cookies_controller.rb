class CookiesController < ApplicationController
  add_flash_types :error

  def display
    @abstractcookies = AbstractCookiesAccept.new
    render "cookies/cookies"
  end

  def post
    @abstractcookies = AbstractCookiesAccept.new
    @abstractcookies.assign_attributes(confirm_params)

    session[:cookies_accepted] = @abstractcookies.cookies_accepted.casecmp("yes").zero?.to_s
    @cookies_accepted = @abstractcookies.cookies_accepted.casecmp("yes").zero?
    @cookies_updated = true

    display
  end

private

  def confirm_params
    params.require(:abstract_cookies_accept).permit(:cookies_accepted)
  end
end
