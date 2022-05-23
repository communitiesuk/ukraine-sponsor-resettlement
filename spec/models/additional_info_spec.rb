require "rails_helper"

RSpec.describe AdditionalInfo, type: :model do
  describe "validations for residential property" do
    it "validates the number of adults is zero when minimum is one" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 0
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
    end

    it "validates the number of adults is one when child at property" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 0
      app.number_children = 1
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
    end

    it "validates the number of adults is empty" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("You must enter a number from 1-9")
    end

    it "validates the number of adults is greater than 9" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("You must enter a number from 1-9")
    end

    it "validates the number of adults is greater than 1" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 2
      expect(app.valid?).to be(true)
      expect(app.errors[:number_adults].length).to be(0)
    end

    it "validates the number of adults when child is greater than 0" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 1
      app.number_children = 5
      expect(app.valid?).to be(true)
      expect(app.errors[:number_adults].length).to be(0)
    end

    it "validates the number of children is not empty" do
      app = described_class.new
      app.different_address = "no"
      app.number_children = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_children].length).to be(1)
      expect(app.errors[:number_children]).to include("You must enter a number from 0-9")
    end

    it "validates the number of children is greater than 9" do
      app = described_class.new
      app.different_address = "no"
      app.number_children = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_children].length).to be(1)
      expect(app.errors[:number_children]).to include("You must enter a number from 0-9")
    end

    it "validates the number of children is greater than 0" do
      app = described_class.new
      app.different_address = "no"
      app.number_children = 2
      expect(app.valid?).to be(true)
      expect(app.errors[:number_children].length).to be(0)
    end
  end

  describe "validations for non residential property" do
    it "validates the number of adults is empty" do
      app = described_class.new
      app.different_address = "yes"
      app.number_adults = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("You must enter a number from 0-9")
    end

    it "validates the number of adults is greater than 9" do
      app = described_class.new
      app.different_address = "yes"
      app.number_adults = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("You must enter a number from 0-9")
    end

    it "validates the number of adults is zero when the number of children is 1" do
      app = described_class.new
      app.different_address = "yes"
      app.number_adults = 0
      app.number_children = 1
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults].length).to be(1)
      expect(app.errors[:number_adults]).to include("There must be at least 1 adult living with children")
    end

    it "validates the number of adults is greater than 1" do
      app = described_class.new
      app.different_address = "yes"
      app.number_adults = 2
      expect(app.valid?).to be(true)
      expect(app.errors[:number_adults].length).to be(0)
    end

    it "validates the number of children is not empty" do
      app = described_class.new
      app.different_address = "yes"
      app.number_children = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_children].length).to be(1)
      expect(app.errors[:number_children]).to include("You must enter a number from 0-9")
    end

    it "validates the number of children is greater than 9" do
      app = described_class.new
      app.different_address = "yes"
      app.number_children = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_children].length).to be(1)
      expect(app.errors[:number_children]).to include("You must enter a number from 0-9")
    end

    it "validates the number of children is greater than 0" do
      app = described_class.new
      app.different_address = "yes"
      app.number_children = 2
      expect(app.valid?).to be(true)
      expect(app.errors[:number_children].length).to be(0)
    end
  end
end
