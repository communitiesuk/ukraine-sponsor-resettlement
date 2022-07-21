require "rails_helper"
RSpec.describe ApplicationHelper, type: :helper do
  describe "Application helper" do
    it "generates a time expiring jwt with the email" do
      expect(helper.create_expiring_jwt("test@example.com")).not_to be_blank
    end
  end
end
