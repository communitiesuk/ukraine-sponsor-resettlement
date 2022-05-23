require "rails_helper"

RSpec.describe IndividualExpressionOfInterest, type: :model do
  describe "deserialising json into attributes" do
    it "sets attributes based on the json column on load" do
      answers = { family_type: "single_adult", living_space: "rooms_in_home_shared_facilities" }
      id = ActiveRecord::Base.connection.insert("INSERT INTO individual_expressions_of_interest (answers, created_at, updated_at) VALUES ('#{JSON.generate(answers)}', NOW(), NOW())")
      record = described_class.find(id)
      expect(record.family_type).to eq(answers[:family_type])
      expect(record.living_space).to eq(answers[:living_space])
    end
  end

  describe "validations" do
    it "Doesn't validate fields if they are not set" do
      app = described_class.new
      expect(app.valid?).to be(true)
    end

    it "validates that the family_type attribute matches the allowed values if set" do
      app = described_class.new
      app.family_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:family_type]).to include("Please choose one of the options")
      app.family_type = "single_adult"
      expect(app.valid?).to be(true)
    end

    it "validates that the living_space attribute matches the allowed values if set" do
      app = described_class.new
      app.living_space = []
      expect(app.valid?).to be(false)
      expect(app.errors[:living_space]).to include("Please choose one or more of the options")
      app.living_space = %w[rooms_in_home_shared_facilities]
      expect(app.valid?).to be(true)
    end

    it "validates that the step_free attribute matches the allowed values if set" do
      app = described_class.new
      app.step_free = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:step_free]).to include("Please choose one of the options")
      app.step_free = "all"
      expect(app.valid?).to be(true)
    end

    it "validates that the accommodation_length attribute matches the allowed values if set" do
      app = described_class.new
      app.accommodation_length = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:accommodation_length]).to include("Please choose one of the options")
      app.accommodation_length = "from_6_to_9_months"
      expect(app.valid?).to be(true)
    end

    it "validates that the single_room_count attribute is an integer >= 0" do
      app = described_class.new
      app.single_room_count = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:single_room_count]).to include("Please enter a non-negative whole number")
      app.single_room_count = "-1"
      expect(app.valid?).to be(false)
      app.single_room_count = "5"
      expect(app.valid?).to be(true)
    end

    it "validates that the double_room_count attribute is an integer >= 0" do
      app = described_class.new
      app.double_room_count = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:double_room_count]).to include("Please enter a non-negative whole number")
      app.double_room_count = "-1"
      expect(app.valid?).to be(false)
      app.double_room_count = "5"
      expect(app.valid?).to be(true)
    end

    it "validates that the postcode attribute is at least 2 and less than 100 characters" do
      app = described_class.new
      app.postcode = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:postcode]).to include("Please enter a valid UK postcode(s)")
      app.postcode = "A"
      expect(app.valid?).to be(false)
      app.postcode = "X" * 101
      expect(app.valid?).to be(false)
      app.postcode = "AB"
      expect(app.valid?).to be(true)
    end

    it "validates that the postcode attribute list only contains A-Z, 0-9 or commas" do
      app = described_class.new
      app.postcode = "A%"
      expect(app.valid?).to be(false)
      expect(app.errors[:postcode]).to include("Please enter a valid UK postcode(s)")
      app.postcode = "^"
      expect(app.valid?).to be(false)
      expect(app.errors[:postcode]).to include("Please enter a valid UK postcode(s)")
      app.postcode = "A1"
      expect(app.valid?).to be(true)
      app.postcode = "A1,A2"
      expect(app.valid?).to be(true)
    end

    it "validates that the phone_number attribute is correct" do
      app = described_class.new
      app.phone_number = "12345678"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("Please enter a valid phone number")
      app.phone_number = "(12345678)"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("Please enter a valid phone number")
      app.phone_number = "123456789012345"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("Please enter a valid phone number")
      app.phone_number = "123456789XXXXXXXXXXXXXXXXXXXXXXX"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("Please enter a valid phone number")
      app.phone_number = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include("Please enter a valid phone number")
      app.phone_number = "(01234) 567890"
      expect(app.valid?).to be(true)
      app.phone_number = "01234567890"
      expect(app.valid?).to be(true)
      app.phone_number = "01234 567 890"
      expect(app.valid?).to be(true)
    end

    it "validates that the agree_future_contact attribute is correct" do
      app = described_class.new
      app.agree_future_contact = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:agree_future_contact]).to include("Must be accepted")
      app.agree_future_contact = "false"
      expect(app.valid?).to be(false)
      app.agree_future_contact = "true"
      expect(app.valid?).to be(true)
    end

    it "validates that the agree_privacy_statement attribute is correct" do
      app = described_class.new
      app.agree_privacy_statement = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:agree_privacy_statement]).to include("Must be accepted")
      app.agree_privacy_statement = "false"
      expect(app.valid?).to be(false)
      app.agree_privacy_statement = "true"
      expect(app.valid?).to be(true)
    end

    it "validates that the fullname attribute is two words" do
      app = described_class.new
      app.fullname = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("Please enter a valid name")
      app.fullname = "oneword"
      expect(app.valid?).to be(false)
      app.fullname = "first #{'X' * 128}"
      expect(app.valid?).to be(false)
      app.fullname = "two words"
      expect(app.valid?).to be(true)
    end

    it "validates that the fullname attribute does not allowed special characters except '" do
      app = described_class.new
      app.fullname = "Bob!@£$%^&*(){}<>|\\/& Jones"
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("Please enter a valid name")
      app.fullname = "Bob; Jones"
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("Please enter a valid name")
      app.fullname = "Bryan O'Driscoll"
      expect(app.valid?).to be(true)
      app.fullname = "Bryan & Sandra Smith"
      expect(app.valid?).to be(false)
      expect(app.errors[:fullname]).to include("Please enter a valid name")
    end

    it "validates that the email attribute is correct" do
      app = described_class.new
      app.email = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include("Please enter a valid email address")
      app.email = "oneword"
      expect(app.valid?).to be(false)
      app.email = "#{'x' * 120}@domain.com"
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include("Please enter a valid email address")
      app.email = "firstnamelastname0@gmail"
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include("Please enter a valid email address")
      app.email = "first@last.com"
      expect(app.valid?).to be(true)
    end

    it "validates the number of adults at a property is at least 1 when residential property" do
      app = described_class.new
      app.different_address = "no"
      app.number_adults = 0
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
      app.number_adults = 1
      expect(app.valid?).to be(true)
    end

    it "validates the number of adults at a property is at least 0 when not residential property" do
      app = described_class.new
      app.different_address = "yes"
      app.number_adults = -1
      expect(app.valid?).to be(false)
      expect(app.errors[:number_adults]).to include("There must be at least 1 adult living at your residential address")
      app.number_adults = 0
      expect(app.valid?).to be(true)
    end
  end

  describe "setting living_space" do
    it "removes empty elements from the array" do
      app = described_class.new
      app.living_space = ["", "", "rooms_in_home_shared_facilities"]
      expect(app.living_space).to eq(%w[rooms_in_home_shared_facilities])
    end
  end

  describe "#as_json" do
    it "includes all of the answer values" do
      app = described_class.new(family_type: :single_adult, living_space: :rooms_in_home_shared_facilities)
      expect(app.as_json).to eq({ family_type: :single_adult, living_space: :rooms_in_home_shared_facilities })
    end

    it "does not include empty values" do
      app = described_class.new(family_type: :single_adult)
      expect(app.as_json).to eq({ family_type: :single_adult })
    end
  end
end
