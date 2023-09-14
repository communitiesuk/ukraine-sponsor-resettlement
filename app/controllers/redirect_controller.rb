class RedirectController < ApplicationController
    def redirect_homepage
      redirect_to "https://www.gov.uk/register-interest-homes-ukraine", allow_other_host: true
    end
end
