require "rails_helper"

RSpec.describe ContactDetailsValidations, type: :model do
  describe "residential address validations" do
    it "address line 1 is not valid" do
      ["", " ", "X" * 129].each do |value|
        app = AdditionalInfo.new
        app.residential_line_1 = value

        expect(app.valid?).to be(false)
        expect(app.errors[:residential_line_1]).to include("You must enter an address")
      end
    end

    it "address line 1 is valid" do
      app = AdditionalInfo.new
      app.residential_line_1 = "House number & Street name"
      expect(app.valid?).to be(true)
    end

    it "address line 2 is valid" do
      [nil, "", " ", "House name"].each do |value|
        app = AdditionalInfo.new
        app.residential_line_2 = value

        expect(app.valid?).to be(true)
      end
    end

    it "address line 2 does not exceed 128 characters if supplied" do
      app = AdditionalInfo.new
      app.residential_line_2 = "X" * 129

      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_2]).to include("You must enter less than 128 characters")
    end

    it "address town or city is not valid" do
      ["", " ", "X" * 129].each do |value|
        app = AdditionalInfo.new
        app.residential_town = value

        expect(app.valid?).to be(false)
        expect(app.errors[:residential_town]).to include("You must enter a town or city")
      end
    end

    it "address town or city is valid" do
      app = AdditionalInfo.new
      app.residential_town = "Town or city"

      expect(app.valid?).to be(true)
    end

    it "address postcode is not valid" do
      ["", " ", "X" * 129, "XX1 XX", "XX 1XX"].each do |value|
        app = AdditionalInfo.new
        app.residential_postcode = value

        expect(app.valid?).to be(false)
        expect(app.errors[:residential_postcode]).to include("You must enter a valid UK postcode")
      end
    end

    it "address postcode is valid" do
      app = AdditionalInfo.new
      app.residential_postcode = "XX1 1XX"

      expect(app.valid?).to be(true)
    end
  end

  describe "host property validations" do
    it "address line 1 is not valid" do
      ["", " ", "X" * 129].each do |value|
        app = AdditionalInfo.new
        app.property_one_line_1 = value

        expect(app.valid?).to be(false)
        expect(app.errors[:property_one_line_1]).to include("You must enter an address")
      end
    end

    it "address line 1 is valid" do
      app = AdditionalInfo.new
      app.property_one_line_1 = "House number & Street name"

      expect(app.valid?).to be(true)
    end

    it "address line 2 is valid" do
      [nil, "", " ", "House name"].each do |value|
        app = AdditionalInfo.new
        app.property_one_line_2 = value

        expect(app.valid?).to be(true)
      end
    end

    it "address line 2 is invalid over 128 characters" do
      app = AdditionalInfo.new
      app.property_one_line_2 = "X" * 129
      expect(app.valid?).to be(false)
      expect(app.errors[:property_one_line_2]).to include("You must enter less than 128 characters")
    end

    it "address town or city is not valid" do
      ["", " ", "X" * 129].each do |value|
        app = AdditionalInfo.new
        app.property_one_town = value

        expect(app.valid?).to be(false)
        expect(app.errors[:property_one_town]).to include("You must enter a town or city")
      end
    end

    it "address town or city is valid" do
      app = AdditionalInfo.new
      app.property_one_town = "Town or city"

      expect(app.valid?).to be(true)
    end

    it "contact phone is invalid" do
      ["", " ", "X", "01234 567 89"].each do |value|
        app = AdditionalInfo.new
        app.phone_number = value

        expect(app.valid?).to be(false)
        expect(app.errors[:phone_number]).to include("You must enter a valid phone number")
      end
    end

    it "contact phone is valid" do
      app = AdditionalInfo.new
      app.phone_number = "01234 567 890"

      expect(app.valid?).to be(true)
    end
  end
end
