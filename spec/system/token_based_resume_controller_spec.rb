require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "User has been timed out" do
    it "shows time out page and copy" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/session-expired"

      expect(page).to have_content("Your session has timed out due to inactivity")
    end
  end

  describe "User tries to resume their application" do
    it "requires a code otherwise shows an error" do
      new_application = UnaccompaniedMinor.new
      new_application.phone_number = "07511824127"
      new_application.save!

      personal_uuid = SecureRandom.uuid
      new_application_token = ApplicationToken.new(unaccompanied_minor: new_application, magic_link: personal_uuid, token: 456_313, expires_at: (Time.zone.now.utc + 1.hour))
      new_application_token.save!

      visit "/sponsor-a-child/resume-application?uuid=#{personal_uuid}"

      click_button("Continue")
      expect(page).to have_content("The code is required")
    end

    it "requires the code to be numeric otherwise shows an error" do
      new_application = UnaccompaniedMinor.new
      new_application.phone_number = "07511824127"
      new_application.save!

      personal_uuid = SecureRandom.uuid
      new_application_token = ApplicationToken.new(unaccompanied_minor: new_application, magic_link: personal_uuid, token: 456_313, expires_at: (Time.zone.now.utc + 1.hour))
      new_application_token.save!

      visit "/sponsor-a-child/resume-application?uuid=#{personal_uuid}"

      fill_in("6 Digit Code", with: "abcdef")
      click_button("Continue")
      expect(page).to have_content("You must insert a valid 6-digit code")
    end

    it "validates the code and returns an error if an application isn't found" do
      new_application = UnaccompaniedMinor.new
      new_application.phone_number = "07511824127"
      new_application.save!

      personal_uuid = SecureRandom.uuid
      new_application_token = ApplicationToken.new(unaccompanied_minor: new_application, magic_link: personal_uuid, token: 456_313, expires_at: (Time.zone.now.utc + 1.hour))
      new_application_token.save!

      visit "/sponsor-a-child/resume-application?uuid=#{personal_uuid}"

      fill_in("6 Digit Code", with: 123_456)
      click_button("Continue")
      expect(page).to have_content("No application found for this code")
    end

    it "validates the code and returns the correct application" do
      new_application = UnaccompaniedMinor.new
      new_application.phone_number = "07511824127"
      new_application.save!

      personal_uuid = SecureRandom.uuid

      new_application_token = ApplicationToken.new(unaccompanied_minor: new_application, magic_link: personal_uuid, token: 123_456, expires_at: (Time.zone.now.utc + 1.hour))
      new_application_token.save!

      visit "/sponsor-a-child/resume-application?uuid=#{personal_uuid}"

      fill_in("6 Digit Code", with: 123_456)
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "validates the expiry date on the code" do
      new_application = UnaccompaniedMinor.new
      new_application.phone_number = "07511824127"
      new_application.save!

      personal_uuid = SecureRandom.uuid
      new_application_token = ApplicationToken.new(unaccompanied_minor: new_application, magic_link: personal_uuid, token: 456_313, expires_at: (Time.zone.now.utc - 1.hour))
      new_application_token.save!

      visit "/sponsor-a-child/resume-application?uuid=#{personal_uuid}"

      fill_in("6 Digit Code", with: 456_313)
      click_button("Continue")

      expect(page).to have_content("This code has timed out, please request a new one")
    end
  end
end
