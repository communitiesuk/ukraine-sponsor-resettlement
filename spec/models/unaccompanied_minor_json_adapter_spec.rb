require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "converting an unaccompanied minor to json" do
    it "validates against the schema" do
      app = described_class.new
      app.save!

      populate_eligibility_and_extras(app)
      populate_sponsor_info(app)

      json = JSON.pretty_generate(app.as_json)

      puts json

      expect(json).to match_schema("unaccompanied_minor")
    end
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
    # uam.different_address = "yes"
    uam.identification_type = "passport"
    uam.identification_number = "ABC123"
  end
end
