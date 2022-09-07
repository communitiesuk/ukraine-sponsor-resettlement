require "rails_helper"

RSpec.describe UnaccompaniedMinor, :focus, type: :model do

  describe "completed application" do
    it "as_json outputs the expected attributes" do
        app = described_class.new
        app.save

        # populates the application
        populate_min_valid_section_one(app)
        populate_min_valid_section_two(app)
        populate_min_valid_section_three(app)
        populate_min_valid_section_four(app)

        # check each field's existance and name
        expect(app.as_json[:reference]).to start_with("SPON-")
    end

    def populate_min_valid_section_one(uam)
      uam.has_other_names = "false"
      uam.phone_number = "01234567890"
      uam.nationality = "CH"
    end

    def populate_min_valid_section_two(uam)
      uam.residential_line_1 = "Address line 1"
      uam.residential_town = "Town"
      uam.residential_postcode = "XX1 2XX"
      uam.different_address = "yes"
      uam.other_adults_address = "true"
    end

    def populate_min_valid_section_three(uam)
      uam.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }
      uam.uk_parental_consent_filename = "uk_parental_consent.pdf"
      uam.ukraine_parental_consent_filename = "ukraine_parental_consent.pdf"
    end

    def populate_min_valid_section_four(uam)
      uam.privacy_statement_confirm = "true"
      uam.sponsor_declaration = "true"
    end

    def populate_min_other_adults_section(uam)
      uam.adults_at_address = {}
      uam.adults_at_address.store("123", Adult.new("First name", "Last name", "1990-09-19", "AUS - Australia", "P - 123456789"))
    end

    def populate_incomplete_other_adults_section(uam)
      uam.adults_at_address = {}
      uam.adults_at_address.store("123", Adult.new("First name", "Last name", "1990-09-19", "AUS - Australia"))
    end
  end
end
