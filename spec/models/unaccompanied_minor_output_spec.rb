require "rails_helper"
FULL_ATTRIBUTES_LIST = %i[
  reference
  created_at
  type
  version
  is_under_18
  is_living_december
  is_born_after_december
  is_unaccompanied
  is_consent
  is_committed
  is_permitted
  have_parental_consent
  uk_parental_consent_file_type
  uk_parental_consent_filename
  uk_parental_consent_saved_filename
  uk_parental_consent_file_size
  uk_parental_consent_file_upload_rid
  uk_parental_consent_file_uploaded_timestamp
  ukraine_parental_consent_file_type
  ukraine_parental_consent_filename
  ukraine_parental_consent_saved_filename
  ukraine_parental_consent_file_size
  ukraine_parental_consent_file_upload_rid
  ukraine_parental_consent_file_uploaded_timestamp
  minor_date_of_birth
  minor_date_of_birth_as_string
  given_name
  family_name
  email
  has_other_names
  other_given_name
  other_family_name
  other_names
  phone_number
  identification_type
  identification_number
  no_identification_reason
  nationality
  has_other_nationalities
  other_nationality
  other_nationalities
  residential_line_1
  residential_line_2
  residential_town
  residential_postcode
  different_address
  sponsor_address_line_1
  sponsor_address_line_2
  sponsor_address_town
  sponsor_address_postcode
  sponsor_date_of_birth
  sponsor_date_of_birth_as_string
  privacy_statement_confirm
  certificate_reference
  minor_given_name
  minor_family_name
  minor_contact_type
  minor_email
  minor_phone_number
  ip_address
  user_agent
  started_at
  sponsor_declaration
  adult_number
  minor_contact_details
  other_adults_address
  adults_at_address
].sort
RSpec.describe UnaccompaniedMinor, type: :model do
  describe "completed application" do
    it "as_json outputs the expected attributes" do
      app = described_class.new
      app.save!

      # populates the application
      populate_eligibility_and_extras(app)
      populate_sponsor_info(app)
      populate_minor_details(app)
      populate_documents(app)
      populate_confirmation(app)

      expect(app.as_json.keys.sort).to contain_exactly(*FULL_ATTRIBUTES_LIST)
    end

    def populate_eligibility_and_extras(uam)
      uam.ip_address = "127.0.0.1".freeze
      uam.user_agent = '"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'.freeze
      uam.final_submission = true
      uam.started_at = Time.zone.now
      uam.is_living_december = "yes"
      uam.is_under_18 = "yes"
      uam.is_unaccompanied = "no"
      uam.is_consent = "yes"
      uam.is_committed = "yes"
      uam.have_parental_consent = "yes"
      uam.is_permitted = "yes"
      uam.is_born_after_december = "no"
    end

    def populate_sponsor_info(uam)
      uam.given_name = "Firstname"
      uam.family_name = "Familyname"
      uam.phone_number = "07777 123 456"
      uam.email = "test@test.com"
      uam.has_other_names = "false"
      uam.other_family_name = ""
      uam.other_given_name = ""
      uam.other_names = []
      uam.phone_number = "07777 123 456"
      uam.nationality = "nationality"
      uam.sponsor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 36,
      }
      uam.sponsor_date_of_birth_as_string = "1-6-#{Time.zone.now.year - 36}"
      uam.has_other_nationalities = "false"
      uam.other_nationality = ""
      uam.other_nationalities = []
      uam.residential_line_1 = "Address line 1"
      uam.residential_line_2 = "Address line 2"
      uam.residential_town = "Address town"
      uam.residential_postcode = "BS2 0AX"
      uam.other_adults_address = "yes"
      uam.adult_number = 1
      uam.adults_at_address = {}
      uam.adults_at_address.store("123", Adult.new("First name", "Last name", "1990-09-19", "AUS - Australia", "P - 123456789"))
      # DANGER: uam.different_address actually means the user answered "yes" when asked
      # "Will you (the sponsor) be living at this address?"
      uam.different_address = "no"
      uam.sponsor_address_line_1 = "Address line 1"
      uam.sponsor_address_line_2 = "Address line 2"
      uam.sponsor_address_town = "Address town"
      uam.sponsor_address_postcode = "BS2 0AX"
      uam.identification_type = "passport"
      uam.identification_number = "ABC123"
      uam.passport_identification_number = "ABC123"
      uam.no_identification_reason = ""
    end

    def populate_minor_details(uam)
      uam.minor_given_name = "Test"
      uam.minor_family_name = "Familyname"
      uam.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }
      uam.minor_date_of_birth_as_string = "1-6-#{Time.zone.now.year - 5}"
      uam.minor_contact_type = "none"
      uam.minor_email = ""
      uam.minor_phone_number = ""
      uam.minor_contact_details = ""
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
end
