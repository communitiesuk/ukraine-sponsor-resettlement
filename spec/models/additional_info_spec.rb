require "rails_helper"

RSpec.describe AdditionalInfo, type: :model do
  describe "validations" do
    it "validates the number of adults is empty" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("You must enter a number from 1-9")
      app.different_address = "yes"
      app.number_adults = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("You must enter a number from 0-9")
    end

    it "validates the number of adults is not greater than 9" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("You must enter a number from 1-9")
      app.different_address = "yes"
      app.number_adults = 10
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("You must enter a number from 0-9")
    end
    #
    # it "validates the number of adults at a property is at least 1 when residential property" do
    #   app = described_class.new
    #   app.different_address = "no"
    #   app.number_adults = 0
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
    #   app.number_adults = 1
    #   expect(app.valid?).to be(true)
    # end
    #
    # it "validates the number of adults at a property is at least 0 when not residential property" do
    #   app = described_class.new
    #   app.different_address = "yes"
    #   app.number_adults = ""
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_adults]).to include("You must enter a number from 0 to 9")
    #   app.number_adults = -1
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_adults]).to include("You must enter a number from 0 to 9")
    #   app.number_adults = 0
    #   expect(app.valid?).to be(true)
    # end
    #
    # it "validates the number of adults at a property is at least 1 when children is greater than 0" do
    #   app = described_class.new
    #   app.different_address = "yes"
    #   app.number_adults = 0
    #   app.number_children = 1
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at an address with children")
    #   expect(app.errors[:number_adults].length).to be(1)
    #   app.different_address = "no"
    #   app.number_adults = 0
    #   app.number_children = 1
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
    #   expect(app.errors[:number_adults].length).to be(1)
    # end
    #
    # it "validates the number of children at a property is at least 0" do
    #   app = described_class.new
    #   app.number_children = ""
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_children]).to include("You must enter a number from 0 to 9")
    #   app.number_children = -1
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_children]).to include("You must enter a number from 0 to 9")
    #   app.number_children = 10
    #   expect(app.valid?).to be(false)
    #   expect(app.errors[:number_children]).to include("You must enter a number from 0 to 9")
    #   app.number_children = 0
    #   expect(app.valid?).to be(true)
    # end
  end
end
