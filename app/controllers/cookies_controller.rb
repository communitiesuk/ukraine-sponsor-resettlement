class CookiesController < ApplicationController
  add_flash_types :error

  def display
    @abstractcookies = AbstractCookiesAccept.new
    @back_to_link = params["back_to"] || (request.referer.present? ? URI(request.referer).path : "/")
    render "cookies/cookies"
  end

end
