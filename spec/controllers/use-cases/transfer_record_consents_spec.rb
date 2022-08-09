require "spec_helper"

RSpec.describe TransferRecord, type: :feature do
  describe "transferring consent forms" do
    let(:foundry_service) { instance_double("FoundryService") }
    let(:storage_service) { instance_double("StorageService") }
    let(:file_upload_service) { instance_double("FileUploadService") }
    let(:rid) { "ri.attachments.main.attachment-xyz" }
    let(:downloaded_file_path) { "/tmp/somefile.pdf" }
    let(:uam) do
      UnaccompaniedMinor.new(
        { id: 42,
          reference: "SPON-1358-4048-A",
          uk_parental_consent_saved_filename: "XX1B0062-A0D5-4EF6-929E-65350544499E-boat.jpeg",
          uk_parental_consent_filename: "boat.jpeg" },
      )
    end

    before do
      allow(UnaccompaniedMinor).to receive(:find).and_return(uam)
      allow(storage_service).to receive(:download).and_return(downloaded_file_path)
      allow(file_upload_service).to receive(:upload).and_return(rid)
      allow(foundry_service).to receive(:assign_uploaded_uk_consent_form)
    end

    it "uploads the uk consent form" do
      described_class.execute_unaccompanied_minor_consent_forms(uam.id, storage_service, file_upload_service, foundry_service)

      expect(UnaccompaniedMinor).to have_received(:find).with(uam.id)
      expect(storage_service).to have_received(:download).with(uam.uk_parental_consent_saved_filename)
      expect(file_upload_service).to have_received(:upload).with(downloaded_file_path, uam.uk_parental_consent_filename)
      expect(foundry_service).to have_received(:assign_uploaded_uk_consent_form).with(uam.reference, rid)
      expect(uam.uk_parental_consent_file_upload_rid).to eq(rid)
      expect(uam.uk_parental_consent_file_uploaded_timestamp).to be_between(Time.zone.now.utc - 5.seconds, Time.zone.now.utc + 5.seconds)
      expect(uam).to be_persisted
    end
  end
end
