require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "validations for file upload" do
    it "ensure content type", :focus do
      app = described_class.new
      app.parental_consent_file_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:parental_consent]).to include("You must select a PDF file")
      app.parental_consent_file_type = "application/pdf"
      expect(app.valid?).to be(true)
    end

    it "ensure file name is provided", :focus do
      app = described_class.new
      app.parental_consent_filename = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:parental_consent]).to include("You must select a file")
      app.parental_consent_filename = "name-of-file-uploaded"
      expect(app.valid?).to be(true)
    end
  end
end
