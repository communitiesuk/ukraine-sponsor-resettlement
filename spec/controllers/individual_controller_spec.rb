require "rails_helper"

RSpec.describe IndividualController, type: :controller do
  describe "GET steps renders the appropriate template" do
    it "renders step 1" do
      get :handle_step

      expect(response).to have_http_status(302)
    end

    # it "renders step 999" do
    #   get :display
    #
    #   expect(response).to have_http_status(200)
    # end
  end
end
