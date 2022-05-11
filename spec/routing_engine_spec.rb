require "rails_helper"

RSpec.describe RoutingEngine, type: :model do
  describe "getting next step without routing" do
    it "when current to next step is incremental" do
      application = AdditionalInfo.new

      expect(described_class.get_next_additional_info_step(application, 1)).to be(2)
      expect(described_class.get_next_additional_info_step(application, 2)).to be(3)
      expect(described_class.get_next_additional_info_step(application, 3)).to be(4)
      expect(described_class.get_next_additional_info_step(application, 4)).to be(5)
    end

    it "when next step is dependent on host question" do
      application = AdditionalInfo.new

      application.different_address = "No"
      expect(described_class.get_next_additional_info_step(application, 5)).to be(9)
    end

    it "when next step is dependent on more properties question" do
      application = AdditionalInfo.new

      application.more_properties = "Yes"
      expect(described_class.get_next_additional_info_step(application, 7)).to be(8)
      application.more_properties = "No"
      expect(described_class.get_next_additional_info_step(application, 7)).to be(9)
    end
  end
end
