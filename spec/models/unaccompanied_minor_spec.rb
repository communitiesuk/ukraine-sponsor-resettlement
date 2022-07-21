require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "contact detail validations" do
    it "sponsor full name is valid" do
      app = described_class.new
      app.given_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:given_name]).to include("You must enter a valid given name")
      expect(app.errors[:given_name].count).to be(1)
      app.family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:family_name]).to include("You must enter a valid family name")
      expect(app.errors[:family_name].count).to be(1)
      app.given_name = ""
      app.family_name = "Smith"
      expect(app.valid?).to be(false)
      expect(app.errors[:given_name]).to include("You must enter a valid given name")
      expect(app.errors[:given_name].count).to be(1)
      app.given_name = "John"
      app.family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:family_name]).to include("You must enter a valid family name")
      expect(app.errors[:family_name].count).to be(1)
      app.given_name = "John"
      app.family_name = "Smith"
      expect(app.valid?).to be(true)
    end

    it "sponsor email is valid" do
      app = described_class.new
      app.email = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include("You must enter a valid email address")
      expect(app.errors[:email].count).to be(1)
      app.email = "John.Smith@"
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include("You must enter a valid email address")
      expect(app.errors[:email].count).to be(1)
      app.email = "John.Smith@test.com"
      expect(app.valid?).to be(true)
    end

    it "sponsor phone is valid" do
      app = described_class.new
      app.phone_number = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("You must enter a valid phone number")
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "07777 888 99"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("You must enter a valid phone number")
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "123456789012345"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("You must enter a valid phone number")
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "07777 888 999"
      expect(app.valid?).to be(true)
    end

    it "sponsor address line 1 is valid" do
      app = described_class.new
      app.residential_line_1 = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include("You must enter an address")
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = "A"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include("You must enter an address")
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include("You must enter an address")
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = "Address line 1"
      expect(app.valid?).to be(true)
    end

    it "sponsor address line 2 is valid" do
      app = described_class.new
      app.residential_line_2 = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_2]).to include("You must enter less than 128 characters")
      expect(app.errors[:residential_line_2].count).to be(1)
      app.residential_line_2 = ""
      expect(app.valid?).to be(true)
      app.residential_line_2 = "A"
      expect(app.valid?).to be(true)
      app.residential_line_2 = "Address line 2"
      expect(app.valid?).to be(true)
    end

    it "sponsor address town is valid" do
      app = described_class.new
      app.residential_town = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include("You must enter a town or city")
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = "A"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include("You must enter a town or city")
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include("You must enter a town or city")
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = "Address town"
      expect(app.valid?).to be(true)
    end

    it "address postcode is valid" do
      app = described_class.new
      app.residential_postcode = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      app.residential_postcode = " "
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      app.residential_postcode = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      app.residential_postcode = "XX1 XX"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      app.residential_postcode = "XX 1XX"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      app.residential_postcode = "XX1 1XX"
      expect(app.valid?).to be(true)
    end
  end

  describe "parental consent questions" do
    it "ensure content type" do
      app = described_class.new
      app.uk_parental_consent_file_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("You can only upload PDF, JPEG or PNG files")
      app.uk_parental_consent_file_type = "application/pdf"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/png"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/jpg"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/jpeg"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "APPLICATION/PDF"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/PNG"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/JPG"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/JPEG"
      expect(app.valid?).to be(true)
    end

    it "ensure the file is 20MB or smaller" do
      app = described_class.new
      app.uk_parental_consent_file_size = 1024**21
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("Your file must be smaller than 20MB")
      app.uk_parental_consent_file_size = 1024**20
      expect(app.valid?).to be(true)
      app.ukraine_parental_consent_file_size = 1024**21
      expect(app.valid?).to be(false)
      expect(app.errors[:ukraine_parental_consent]).to include("Your file must be smaller than 20MB")
      app.ukraine_parental_consent_file_size = 1024**20
      expect(app.valid?).to be(true)
    end

    it "ensure file name is provided" do
      app = described_class.new
      app.uk_parental_consent_filename = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("You must choose a file")
      app.uk_parental_consent_filename = "name-of-file-uploaded"
      expect(app.valid?).to be(true)
    end

    it "validates that the have parental consent forms attribute is selected" do
      app = described_class.new
      app.have_parental_consent = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:have_parental_consent]).to include("You must select an option to continue")
      app.have_parental_consent = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "age validations, minor is less than 18" do
    app = described_class.new

    it "shows error when any input is empty" do
      app.minor_date_of_birth = { 3 => nil, 2 => "2", 1 => "2010" }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)

      app.minor_date_of_birth = { 3 => "1", 2 => nil, 1 => "2013" }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)

      app.minor_date_of_birth = { 3 => "3", 2 => "9", 1 => nil }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
    end

    it "shows error if minor is over 18" do
      app.minor_date_of_birth = { 3 => "1", 2 => "6", 1 => "2001" }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("They must be under 18 to be considered a child in the UK")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
    end

    it "shows error if date of birth is current day or in future" do
      app.minor_date_of_birth = { 3 => Time.zone.now.day.to_s, 2 => Time.zone.now.month.to_s, 1 => Time.zone.now.year.to_s }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
    end

    it "is valid when minor under 18" do
      year = (Time.zone.now.year - 4).to_s
      app.minor_date_of_birth = { 3 => "21", 2 => "6", 1 => year }
      expect(app.valid?).to be(true)
    end

    it "sponsor is greater than 18" do
      app = described_class.new
      app.sponsor_date_of_birth = {}
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => 2022, "2" => 6, "3" => 21 }
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("A sponsor with this date of birth is less 18 and you cannot use this service to apply to sponsor them")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => Time.zone.now.year, "2" => Time.zone.now.month, "3" => Time.zone.now.day }
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => 2004, "2" => 6, "3" => 22 }
      expect(app.valid?).to be(true)
    end
  end

  describe "accept privacy terms" do
    it "validates that the have privacy terms is selected" do
      app = described_class.new
      app.privacy_statement_confirm = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:privacy_statement_confirm]).to include("You must read and agree to the privacy statement")
      app.privacy_statement_confirm = "false"
      expect(app.valid?).to be(false)
      expect(app.errors[:privacy_statement_confirm]).to include("You must read and agree to the privacy statement")
      app.privacy_statement_confirm = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "accept sponsor declaration" do
    it "validates that the have sponsor checkbox is selected" do
      app = described_class.new
      app.sponsor_declaration = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_declaration]).to include("You must confirm you are eligible")
      app.sponsor_declaration = "false"
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_declaration]).to include("You must confirm you are eligible")
      app.sponsor_declaration = "true"
      expect(app.valid?).to be(true)
    end
  end

  describe "task list status styles" do
    it "return style for status name" do
      app = described_class.new
      expect(app.status_styles?("Cannot start yet")).to eq("govuk-tag--grey")
      expect(app.status_styles?("Not started")).to eq("govuk-tag--grey")
      expect(app.status_styles?("In progress")).to eq("govuk-tag--blue")
      expect(app.status_styles?("Completed")).to eq("")
    end
  end

  describe "task list sponsor details" do
    it "return status for names" do
      app = described_class.new
      expect(app.sponsor_details_names?).to eq("Not started")
      app.given_name = "Bob"
      app.family_name = "Smith"
      expect(app.sponsor_details_names?).to eq("In progress")
      app.has_other_names = "true"
      expect(app.sponsor_details_names?).to eq("Completed")
    end

    it "return status for contact details" do
      app = described_class.new
      expect(app.sponsor_details_contact_details?).to eq("Not started")
      app.email = "test@test.com"
      expect(app.sponsor_details_contact_details?).to eq("In progress")
      app.phone_number = "07777 123 456"
      expect(app.sponsor_details_contact_details?).to eq("Completed")
    end

    it "return status for additional details" do
      app = described_class.new
      expect(app.sponsor_details_additional_details?).to eq("Not started")
      app.no_identification_reason = "reason"
      expect(app.sponsor_details_additional_details?).to eq("In progress")
      app.nationality = "nationality"
      expect(app.sponsor_details_additional_details?).to eq("Completed")
    end

    it "return status for address", :focus do
      app = described_class.new
      expect(app.sponsor_address_details?).to eq("Not started")
      app.residential_line_1 = "address line 1"
      expect(app.sponsor_address_details?).to eq("In progress")
      app.other_adults_address = "no"
      expect(app.sponsor_address_details?).to eq("Completed")
    end
  end

  describe "child flow validation" do
    it "child's given and family name" do
      app = described_class.new
      app.minor_given_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_given_name]).to include("You must enter a valid given name")
      expect(app.errors[:minor_given_name].count).to be(1)
      app.minor_family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_family_name]).to include("You must enter a valid family name")
      expect(app.errors[:minor_family_name].count).to be(1)
      app.minor_given_name = ""
      app.minor_family_name = "Smith"
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_given_name]).to include("You must enter a valid given name")
      expect(app.errors[:minor_given_name].count).to be(1)
      app.minor_given_name = "John"
      app.minor_family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_family_name]).to include("You must enter a valid family name")
      expect(app.errors[:minor_family_name].count).to be(1)
      app.minor_given_name = "John"
      app.minor_family_name = "Smith"
      expect(app.valid?).to be(true)
    end
  end

  describe "address formatting" do
    it "show address when address line 2 blank" do
      app = described_class.new
      app.residential_line_1 = "Address line 1"
      app.residential_town = "Town"
      app.residential_postcode = "AA1 1AA"

      expect(app.formatted_address?).to eq("Address line 1, Town, AA1 1AA")
    end

    it "show address when address line 2 not blank" do
      app = described_class.new
      app.residential_line_1 = "Address line 1"
      app.residential_line_2 = "Address line 2"
      app.residential_town = "Town"
      app.residential_postcode = "AA1 1AA"

      expect(app.formatted_address?).to eq("Address line 1, Address line 2, Town, AA1 1AA")
    end
  end
end
