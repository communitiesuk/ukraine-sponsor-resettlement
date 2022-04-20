require "rails_helper"

RSpec.describe RoutingEngine, type: :model do
  describe "getting next step without routing" do
    it "when current to next step is incremental" do
      application = AdditionalInfo.new

      expect(RoutingEngine.get_next_step(application, 1)).to be(2)
      expect(RoutingEngine.get_next_step(application,2)).to be(3)
      expect(RoutingEngine.get_next_step(application,3)).to be(4)
      expect(RoutingEngine.get_next_step(application,4)).to be(5)
    end

    it "when next step is dependent on application data" do
      application = AdditionalInfo.new

      application.residential_host = "Yes"
      expect(RoutingEngine.get_next_step(application, 5)).to be(6)
      application.residential_host = "Yes"
      expect(RoutingEngine.get_next_step(application, 6)).to be(99)
      application.residential_host = "Yes"
      expect(RoutingEngine.get_next_step(application, 99)).to be(999)
      application.residential_host = "No"
      expect(RoutingEngine.get_next_step(application, 5)).to be(7)
    end
  end
end
