require "rails_helper"

RSpec.describe FraudController, :focus, type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

    describe "directs to external link if the box is checked" do
      it "redirects back to fraud page if the checkbox is unticked" do
        visit "/fraud-support"
        page.check("abstract-confirm-confirm-and-continue-1-field")
        click_button("Start Now")
        
        expect(page).to have_content("How this works")
       
      end

      it "redirects back to fraud page if the checkbox is unticked" do 
        visit "/fraud-support"
        click_button("Start Now")

        expect(page).to have_content("You must confirm to continue")
      end 
    end
end