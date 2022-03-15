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
    it "validates that the family or single type matches the allowed values if set" do
      app = described_class.new
      app.family_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:family_type]).to include("Please choose one of the options")
    end

    it "validates that the living space type matches the allowed values if set" do
      app = described_class.new
      app.living_space = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:living_space]).to include("Please choose one of the options")
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
