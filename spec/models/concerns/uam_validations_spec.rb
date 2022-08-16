require "rails_helper"

RSpec.describe UamValidations, type: :model do
  describe "sponsor residential address validations" do
    it "address line 1 is not valid when nil or empty" do
      uam = UnaccompaniedMinor.new

      uam.final_submission = true
      ### mmmmm, maybe should test via the controller?
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

      uam.different_address = "no"

      uam.sponsor_address_line_1 = nil
      expect(uam.valid?).to be(false)
      expect(uam.errors[:sponsor_address_line_1]).to include("You must enter an address")

      uam.sponsor_address_line_1 = ""
      expect(uam.valid?).to be(false)
      expect(uam.errors[:sponsor_address_line_1]).to include("You must enter an address")

      uam.sponsor_address_line_1 = " "
      expect(uam.valid?).to be(false)
      expect(uam.errors[:sponsor_address_line_1]).to include("You must enter an address")
    end
  end
end
