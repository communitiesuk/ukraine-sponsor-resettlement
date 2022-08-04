require "rails_helper"

RSpec.describe UnaccompaniedController, type: :controller do
  describe "Submits" do
    uam = UnaccompaniedMinor.new
    uam.ip_address = "127.0.0.1".freeze
    uam.user_agent = '"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'.freeze
    uam.final_submission = true

    uam.is_living_december = "yes"
    uam.is_under_18 = "yes"
    uam.is_unaccompanied = "no"
    uam.is_consent = "yes"
    uam.is_committed = "yes"
    uam.have_parental_consent = "yes"
    uam.is_permitted = "yes"

    uam.given_name = "Firstname"
    uam.family_name = "Familyname"
    uam.phone_number = "07777 123 456"
    uam.email = "test@test.com"
    uam.has_other_names = "false"
    uam.phone_number = "07777 123 456"
    uam.nationality = "nationality"
    uam.sponsor_date_of_birth = {
      3 => 1,
      2 => 6,
      1 => Time.zone.now.year - 36,
    }
    uam.residential_line_1 = "Address line 1"
    uam.residential_line_2 = "Address line 2"
    uam.residential_town = "Address town"
    uam.residential_postcode = "BS2 0AX"
    uam.other_adults_address = "no"
    uam.different_address = "no"

    uam.identification_type = "passport"
    uam.identification_number = "ABC123"
    uam.passport_identification_number = "ABC123"

    uam.other_adults_address = "no"

    uam.minor_given_name = "Test"
    uam.minor_family_name = "Familyname"
    uam.minor_date_of_birth_day = 1
    uam.minor_date_of_birth_month = 1
    uam.minor_date_of_birth_year = 2020
    uam.minor_contact_type = "none"
    uam.minor_email = ""
    uam.minor_phone_number = ""

    uam.uk_parental_consent_filename = "uk_consent.jpg"
    uam.uk_parental_consent_saved_filename = "ACCB3CE3-A49A-4589-BEC1-7FAC3B45F234-neil-avatar.jpg"
    uam.uk_parental_consent_file_type = "image/jpeg"
    uam.uk_parental_consent_file_size = 35_552
    uam.ukraine_parental_consent_filename = "ukraine_consent.jpg"
    uam.ukraine_parental_consent_saved_filename = "ACCB3CE3-A49A-4589-BEC1-7FAC3B45F234-neil-avatar.jpg"
    uam.ukraine_parental_consent_file_type = "image/jpeg"
    uam.ukraine_parental_consent_file_size = 35_552

    uam.privacy_statement_confirm = "true"
    uam.sponsor_declaration = "true"

    before do
      allow(UnaccompaniedMinor).to receive(:find_by_reference).and_return(uam)
      allow(SendUnaccompaniedMinorJob).to receive(:perform_later)
    end

    it "strips uneeded errors and submits. Lord forgive us" do
      post :submit

      expect(uam.errors.empty?).to be(true)
      expect(SendUnaccompaniedMinorJob).to have_received(:perform_later).with(uam.id)
      expect(response).to redirect_to("/sponsor-a-child/confirm")
    end
  end
end
