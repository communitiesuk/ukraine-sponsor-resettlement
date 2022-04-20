require "rails_helper"

RSpec.describe RoutingEngine, type: :model do
  describe "getting next step without routing" do
    it "when current to next step is incremental" do
      expect(RoutingEngine.get_next_step(1)).to be(2)
      expect(RoutingEngine.get_next_step(2)).to be(3)
      expect(RoutingEngine.get_next_step(3)).to be(4)
      expect(RoutingEngine.get_next_step(4)).to be(5)
    end
  end
end
