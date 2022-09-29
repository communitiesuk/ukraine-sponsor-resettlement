require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  describe "converting an unaccompanied minor to json" do
    fit "validates against the schema" do
      app = described_class.new
      app.save!

      populate_eligibility_and_extras(app)

      json = JSON.generate(app.as_json)

      puts json

      expect(json).to match_schema("unaccompanied_minor")
    end
  end

  def populate_eligibility_and_extras(uam)
    uam.ip_address = "127.0.0.1".freeze
    uam.user_agent = '"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'.freeze
    uam.final_submission = false
    uam.started_at = Time.zone.now
    uam.is_living_december = "yes"
    uam.is_under_18 = "yes"
    uam.is_unaccompanied = "no"
    uam.is_consent = "yes"
    uam.is_committed = "yes"
    uam.have_parental_consent = "yes"
    uam.is_permitted = "yes"
  end
end
