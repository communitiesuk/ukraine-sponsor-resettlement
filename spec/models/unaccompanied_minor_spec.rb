require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "full name validations" do
    it "minor full name is valid", :focus do
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
      app.fullname = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("You must enter your full name")
      expect(app.errors[:fullname].count).to be(1)
      app.fullname = "John"
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("You must enter your full name")
      expect(app.errors[:fullname].count).to be(1)
      app.fullname = "John Smith"
      expect(app.valid?).to be(true)
    end
  end

  describe "parental consent questions" do
    it "ensure content type" do
      app = described_class.new
      app.parental_consent_file_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:parental_consent]).to include("You must select a PDF file")
      app.parental_consent_file_type = "application/pdf"
      expect(app.valid?).to be(true)
    end

    it "ensure file name is provided" do
      app = described_class.new
      app.parental_consent_filename = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:parental_consent]).to include("You must select a file")
      app.parental_consent_filename = "name-of-file-uploaded"
      expect(app.valid?).to be(true)
    end

    it "validates that the have parental consent forms attribute is selected", :focus do
      app = described_class.new
      app.have_parental_consent = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:have_parental_consent]).to include("You must select an option to continue")
      app.have_parental_consent = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "age validations" do
    it "minor is less than 18", :focus do
      app = described_class.new
      app.minor_date_of_birth = {}
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => 2001, "2" => 6, "3" => 1 } #not ideal, but will 'work'
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("A person with this date of birth is over 18 and you cannot use this service to apply to sponsor them")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => DateTime.now.year, "2" => DateTime.now.month, "3" => DateTime.now.day }
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:minor_date_of_birth].count).to be(1)
      app.minor_date_of_birth = { "1" => 2022, "2" => 6, "3" => 21 } #not ideal, but will 'work' for about 18 years
      expect(app.valid?).to be(true)
    end

    it "sponsor is greater than 18", :focus do
      app = described_class.new
      app.sponsor_date_of_birth = {}
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => 2022, "2" => 6, "3" => 21 } #not ideal, but will 'work' for about 18 years
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("A sponsor with this date of birth is less 18 and you cannot use this service to apply to sponsor them")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => DateTime.now.year, "2" => DateTime.now.month, "3" => DateTime.now.day }
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include("Enter a valid date of birth")
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = { "1" => 2004, "2" => 6, "3" => 22 } #not ideal, but will 'work'
      expect(app.valid?).to be(true)
    end
  end
end
