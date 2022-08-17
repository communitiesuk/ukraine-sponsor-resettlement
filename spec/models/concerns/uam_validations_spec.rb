require "rails_helper"

RSpec.describe UamValidations, type: :model do
  describe "sponsor residential address validations" do
    it "raises an error message when address line 1 is nil or empty" do
      empty_lines = [nil, "", " "]

      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_line_1 = line

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_line_1)
      end
    end

    it "raises an error message when address town is nil or empty" do
      empty_lines = [nil, "", " "]

      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_town = line

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_town)
      end
    end

    it "raises an error message when postcode is nil or empty" do
      empty_lines = [nil, "", " "]

      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_postcode = line

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_postcode)
      end
    end

    it "does not raise an error message when address line 2 is nil or empty" do
      empty_lines = [nil, "", " "]

      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_line_2 = line

        # Will not be valid because other validations currently fail.
        expect(uam.valid?).to be(false)

        expect(uam.errors).not_to include(:sponsor_address_line_2)
      end
    end

    it "does not raise an error message when mandatory fields are complete" do
      uam = new_uam
      uam.sponsor_address_line_1 = "1 Some Street"
      uam.sponsor_address_town = "Town"
      uam.sponsor_address_postcode = "ST1 1LX"

      # Will not be valid because other validations currently fail.
      expect(uam.valid?).to be(false)
      expect(uam.errors).not_to include(:sponsor_address_line_1)
      expect(uam.errors).not_to include(:sponsor_address_town)
      expect(uam.errors).not_to include(:sponsor_address_postcode)
    end

    def new_uam
      uam = UnaccompaniedMinor.new
      # DANGER: uam.different_address actually means the user answered "yes" or "no" when asked
      # "Will you (the sponsor) be living at this address?"
      #
      # Setting this to "no" makes the validators run on the address fields
      uam.different_address = "no"

      # Set dummy attributes to satisfy other validators 😒
      uam.final_submission = true
      uam.uk_parental_consent_file_size = 1
      uam.ukraine_parental_consent_file_size = 1
      uam.sponsor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 36,
      }
      uam.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }

      uam
    end
  end
end
