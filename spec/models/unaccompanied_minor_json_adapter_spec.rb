require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "converting an unaccompanied minor to json" do
    fit "validates against the schema" do
      app = described_class.new
      app.save!


      json = JSON.generate(app.as_json)

      p json

      expect(json).to match_schema("unaccompanied_minor")
    end
  end
end
