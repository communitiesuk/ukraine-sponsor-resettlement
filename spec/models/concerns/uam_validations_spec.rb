require "rails_helper"

RSpec.describe UamValidations, type: :model do
  describe "sponsor residential address validations" do
    let(:empty_lines) { [nil, "", " "].freeze }
    let(:task_list_url) { "/sponsor-a-child/task-list" }

    it "raises an error message when address line 1 is nil or empty" do
      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_line_1 = line
        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_line_1), "Failed value:#{line}"
      end
    end

    it "raises an error message when address town is nil or empty" do
      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_town = line

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_town), "Failed value:#{line}"
      end
    end

    it "raises an error message when postcode is nil or empty" do
      empty_lines.each do |line|
        uam = new_uam
        uam.sponsor_address_postcode = line

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_postcode), "Failed value:#{line}"
      end
    end

    it "raises an error message when postcode is invalid" do
      invalid_postcodes = ["W1", "HEllo World", "blah"].freeze

      invalid_postcodes.each do |postcode|
        uam = new_uam
        uam.sponsor_address_postcode = postcode

        expect(uam.valid?).to be(false)
        expect(uam.errors).to include(:sponsor_address_postcode), "Failed value:#{postcode}"
      end
    end

    it "does not raise an error message when address line 2 is nil or empty" do
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

    it "allows odt files to be uploaded" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url

      click_link("Upload Ukrainian consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.odt")

      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.ukraine_parental_consent_file_type).to eq(application/vnd.oasis.opendocument.text)
    end

    def new_uam
      uam = UnaccompaniedMinor.new
      # DANGER: uam.different_address actually means the user answered "yes" or "no" when asked
      # "Will you (the sponsor) be living at this address?"
      #
      # Setting this to "no" makes the validators run on the address fields
      uam.different_address = "no"

      # Set dummy attributes to satisfy other validators 😒
      uam.partial_validation = [:full_validation]
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
