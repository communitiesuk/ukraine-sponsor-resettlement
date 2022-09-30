require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "converting an unaccompanied minor to json" do
    it "validates against the schema" do
      app = described_class.new
      app.save!

      populate_eligibility_and_extras(app)
      populate_sponsor_info(app)
      populate_minor_details(app)
      populate_documents(app)
      populate_confirmation(app)

      json = adapt_it_to_json(app)

      puts json

      expect(json).to match_schema("unaccompanied_minor")
    end
  end

  def adapt_it_to_json(uam)
    compacted_hash = uam.as_json
    compacted_hash.except!(:minor_email_confirm)
    compacted_hash.except!(:minor_phone_number_confirm)
    compacted_hash.except!(:uk_parental_consent_file_upload_rid)
    compacted_hash.except!(:uk_parental_consent_file_uploaded_timestamp)
    compacted_hash.except!(:uk_parental_consent_saved_filename)
    compacted_hash.except!(:ukraine_parental_consent_file_upload_rid)
    compacted_hash.except!(:ukraine_parental_consent_file_uploaded_timestamp)
    compacted_hash.except!(:ukraine_parental_consent_saved_filename)

    JSON.pretty_generate(compacted_hash)
  end

  def populate_eligibility_and_extras(uam)
    uam.ip_address = "127.0.0.1".freeze
    uam.user_agent = '"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'.freeze
    uam.final_submission = false
    uam.started_at = Time.zone.now
    uam.is_living_december = "yes"
    uam.is_under_18 = "yes"
    uam.is_unaccompanied = "no"
    uam.is_consent = "yes"
    uam.is_committed = "yes"
    uam.have_parental_consent = "yes"
    uam.is_permitted = "yes"
  end

  def populate_sponsor_info(uam)
    uam.given_name = "Firstname"
    uam.family_name = "Familyname"
    uam.phone_number = "07777 123 456"
    uam.email = "sponsor@example.com"
    uam.has_other_names = "false"
    uam.nationality = "GBR - United Kingdom"
    uam.sponsor_date_of_birth = {
      3 => 1,
      2 => 6,
      1 => Time.zone.now.year - 36,
    }
    uam.has_other_nationalities = "false"
    uam.residential_line_1 = "Address line 1"
    uam.residential_line_2 = "Address line 2"
    uam.residential_town = "Address town"
    uam.residential_postcode = "BS2 0AX"
    uam.other_adults_address = "no"
    # DANGER: uam.different_address actually means the user answered "yes" when asked
    # "Will you (the sponsor) be living at this address?"
    uam.different_address = "yes"
    uam.identification_type = "passport"
    uam.identification_number = "ABC123"
  end

  def populate_minor_details(uam)
    uam.minor_given_name = "MinorGivenName"
    uam.minor_family_name = "MinorFamilyName"
    uam.minor_date_of_birth = {
      3 => 1,
      2 => 6,
      1 => Time.zone.now.year - 5,
    }
    uam.minor_contact_type = [
      "",
      "none",
    ]
    uam.minor_email = ""
    uam.minor_email_confirm = ""
    uam.minor_phone_number = ""
    uam.minor_phone_number_confirm = ""
  end

  def populate_documents(uam)
    uam.uk_parental_consent_file_upload_rid = "123"
    uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now
    uam.uk_parental_consent_filename = "uk_consent.jpg"
    uam.uk_parental_consent_saved_filename = "ACCB3CE3-A49A-4589-BEC1-7FAC3B45F234-neil-avatar.jpg"
    uam.uk_parental_consent_file_type = "image/jpeg"
    uam.uk_parental_consent_file_size = 35_552
    uam.ukraine_parental_consent_file_upload_rid = "123"
    uam.ukraine_parental_consent_file_uploaded_timestamp = Time.zone.now
    uam.ukraine_parental_consent_filename = "ukraine_consent.jpg"
    uam.ukraine_parental_consent_saved_filename = "ACCB3CE3-A49A-4589-BEC1-7FAC3B45F234-neil-avatar.jpg"
    uam.ukraine_parental_consent_file_type = "image/jpeg"
    uam.ukraine_parental_consent_file_size = 35_552
  end

  def populate_confirmation(uam)
    uam.privacy_statement_confirm = "true"
    uam.sponsor_declaration = "true"
  end
end
