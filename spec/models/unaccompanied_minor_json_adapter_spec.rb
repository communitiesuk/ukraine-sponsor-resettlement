require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "converting an unaccompanied minor to json" do
    it "validates against the schema" do
      app = described_class.new
      json = JSON.generate(app.as_json)

      expect(json).to match_response_schema("unaccompanied_minor")
    end
  end
end
