require "rails_helper"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "submitting the form" do
    it "saves all of the answers in the database", :focus do
      visit "/unaccompanied-minor"
      expect(page).to have_content("Apply for certification to sponsor a child travelling on their own")

      click_link("Start now")

      # expect(page).to have_content("Upload your notarised parental written consent")
      #
      # test_file_path = File.join(File.dirname(__FILE__), "..", "test-document.pdf")
      #
      # Rails.logger.debug File.exist? test_file_path
      #
      # attach_file("unaccompanied-minor-parental-consent-field", test_file_path)
      # click_button("Upload")

      fill_in("What is the name of the child you want to sponsor?", with: "John Smith")
      click_button("Continue")

      # expect(page).to have_content("Consent test-document.pdf")
      expect(page).to have_content("Child name John Smith")

      click_button("Accept and send")

      expect(page).to have_content("Application complete")

      application = UnaccompaniedMinor.order("created_at DESC").last
      expect(application.as_json).to include({
                                                 minor_fullname: "John Smith",
      })

      expect(application.ip_address).to eq("127.0.0.1")
      expect(application.user_agent).to eq("DummyBrowser")
      expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    end
  end
end
