require "spec_helper"

RSpec.describe TransferRecord, type: :feature do
  describe "transferring consent forms" do
    let(:unaccompanied_minor) { instance_double("UnaccompaniedMinor") }

    before do
      allow(UnaccompaniedMinor).to receive(:find).and_return(nil)
    end

    it "calls the uam finder with the correct record id" do
      uam_id = 1
      described_class.execute_unaccompanied_minor_consent_forms(uam_id)

      expect(UnaccompaniedMinor).to have_received(:find).with(uam_id)
    end
  end
end
