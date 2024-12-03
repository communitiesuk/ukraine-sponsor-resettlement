require "spec_helper"

RSpec.describe TransferConsents, type: :feature do
  describe "transferring consent forms" do
    let(:foundry_service) { instance_double(FoundryService) }
    let(:storage_service) { instance_double(StorageService) }
    let(:file_upload_service) { instance_double(FileUploadService) }
    let(:uk_rid) { "ri.attachments.main.attachment-xyz" }
    let(:ukraine_rid) { "ri.attachments.main.attachment-ua" }
    let(:downloaded_file_path) { "/tmp/somefile.pdf" }
    let(:ukraine_downloaded_file_path) { "/tmp/uaconsent.jpeg" }
    let(:uam) do
      UnaccompaniedMinor.new(
        { id: 42,
          reference: "SPON-1358-4048-A",
          uk_parental_consent_saved_filename: "XX1B0062-A0D5-4EF6-929E-65350544499E-boat.jpeg",
          uk_parental_consent_filename: "boat.jpeg",
          ukraine_parental_consent_saved_filename: "UA1B0062-A0D5-4EF6-929E-65350544499E-uaconsent.jpeg",
          ukraine_parental_consent_filename: "uaconsent.jpeg" },
      )
    end

    before do
      allow(UnaccompaniedMinor).to receive(:find).and_return(uam)

      # UK Consent form
      allow(storage_service).to receive(:download)
      .with(uam.uk_parental_consent_saved_filename)
      .and_return(downloaded_file_path)

      allow(file_upload_service).to receive(:upload)
      .with(downloaded_file_path, uam.uk_parental_consent_filename)
      .and_return(uk_rid)

      allow(foundry_service).to receive(:assign_uploaded_uk_consent_form)
      .with(uam.reference, uk_rid)

      # UA Consent form
      allow(storage_service).to receive(:download)
      .with(uam.ukraine_parental_consent_saved_filename)
      .and_return(ukraine_downloaded_file_path)

      allow(file_upload_service).to receive(:upload)
      .with(ukraine_downloaded_file_path, uam.ukraine_parental_consent_filename)
      .and_return(ukraine_rid)

      allow(foundry_service).to receive(:assign_uploaded_ukraine_consent_form)
      .with(uam.reference, ukraine_rid)
    end

    it "uploads the uk and ukraine consent forms" do
      transfer_consents = described_class.new(storage_service, file_upload_service, foundry_service)
      transfer_consents.send(uam.id)

      expect(UnaccompaniedMinor).to have_received(:find).with(uam.id)

      # UK forms
      expect(storage_service).to have_received(:download).with(uam.uk_parental_consent_saved_filename)
      expect(file_upload_service).to have_received(:upload).with(downloaded_file_path, uam.uk_parental_consent_filename)
      expect(foundry_service).to have_received(:assign_uploaded_uk_consent_form).with(uam.reference, uk_rid)
      expect(uam.uk_parental_consent_file_upload_rid).to eq(uk_rid)
      expect(uam.uk_parental_consent_file_uploaded_timestamp).to be_between(Time.zone.now.utc - 5.seconds, Time.zone.now.utc + 5.seconds)

      # UA form
      expect(storage_service).to have_received(:download).with(uam.ukraine_parental_consent_saved_filename)
      expect(file_upload_service).to have_received(:upload).with(ukraine_downloaded_file_path, uam.ukraine_parental_consent_filename)
      expect(foundry_service).to have_received(:assign_uploaded_ukraine_consent_form).with(uam.reference, ukraine_rid)
      expect(uam.ukraine_parental_consent_file_upload_rid).to eq(ukraine_rid)
      expect(uam.ukraine_parental_consent_file_uploaded_timestamp).to be_between(Time.zone.now.utc - 5.seconds, Time.zone.now.utc + 5.seconds)

      expect(uam).to be_persisted
    end
  end
end
