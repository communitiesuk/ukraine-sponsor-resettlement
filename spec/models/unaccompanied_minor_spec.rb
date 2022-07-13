require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "contact detail validations" do
    it "minor full name is valid" do
      app = described_class.new
      app.minor_fullname = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_fullname]).to include("You must enter the child's full name")
      expect(app.errors[:minor_fullname].count).to be(1)
      app.minor_fullname = "John"
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_fullname]).to include("You must enter the child's full name")
      expect(app.errors[:minor_fullname].count).to be(1)
      app.minor_fullname = "John Smith"
      expect(app.valid?).to be(true)
    end

    it "sponsor full name is valid", :focus do
      app = described_class.new
      app.given_name = nil
      app.family_name = nil
      expect(app.valid?).to be(false)
      expect(app.errors[:given_name]).to include("You must enter a valid given name")
      expect(app.errors[:given_name].count).to be(1)
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
      expect(app.errors[:uk_parental_consent]).to include("You must select a PDF file")
      app.uk_parental_consent_file_type = "application/pdf"
      expect(app.valid?).to be(true)
    end

    it "ensure file name is provided" do
      app = described_class.new
      app.uk_parental_consent_filename = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("You must select a file")
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

  describe "age validations" do
    it "minor is less than 18" do
      app = described_class.new
      app.minor_date_of_birth = {}
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => 2001, "2" => 6, "3" => 1 }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("A person with this date of birth is over 18 and you cannot use this service to apply to sponsor them")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => Time.zone.now.year, "2" => Time.zone.now.month, "3" => Time.zone.now.day }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => 2022, "2" => 6, "3" => 21 }
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
      app.agree_privacy_statement = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:agree_privacy_statement]).to include("You must select an option to continue")
      app.agree_privacy_statement = "yes"
      expect(app.valid?).to be(true)
    end
  end
end
