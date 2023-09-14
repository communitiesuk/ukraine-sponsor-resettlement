require "rails_helper"

RSpec.describe RedirectController, type: :controller do
  describe "redirect controller" do
    let(:redirect_govuk_location) { "https://www.gov.uk/register-interest-homes-ukraine" }

    it "redirects the landing page to govuk url" do
        get :redirect_homepage

        expect(response).to redirect_to(redirect_govuk_location)
    end
  end
end
