require "net/http"

class TransferConsents
  def initialize(storage_service = nil, upload_service = nil, foundry_service = nil)
    @storage = storage_service || StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    @uploader = upload_service || FileUploadService.new
    @foundry = foundry_service || FoundryService.new
  end

  def send(record_id)
    uam = UnaccompaniedMinor.find(record_id)

    begin
      uk_rid = transfer(uam.uk_parental_consent_saved_filename, uam.uk_parental_consent_filename)
      @foundry.assign_uploaded_uk_consent_form(uam.reference, uk_rid)
      uam.uk_parental_consent_file_upload_rid = uk_rid
      uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

      ukraine_rid = transfer(uam.ukraine_parental_consent_saved_filename, uam.ukraine_parental_consent_filename)
      @foundry.assign_uploaded_ukraine_consent_form(uam.reference, ukraine_rid)
      uam.ukraine_parental_consent_file_upload_rid = ukraine_rid
      uam.ukraine_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

      uam.save!(validate: false)
    rescue StandardError => e
      Rails.logger.error "Error uploading consent forms. #{e.message}"
      raise e
    end
  end

private

  def transfer(s3_filename, actual_filename)
    file_path = @storage.download(s3_filename)
    @uploader.upload(file_path, actual_filename)
  end
end
