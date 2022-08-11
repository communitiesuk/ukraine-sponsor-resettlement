require "net/http"

class TransferConsents
  def initialize(storage_service = nil, upload_service = nil, foundry_service = nil)
    @storage = storage_service || StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    @uploader = upload_service || FileUploadService.new
    @foundry = foundry_service || FoundryService.new
  end

  def send(record_id)
    uam = UnaccompaniedMinor.find(record_id)

    # UK
    file_path = @storage.download(uam.uk_parental_consent_saved_filename)
    rid = @uploader.upload(file_path, uam.uk_parental_consent_filename)
    @foundry.assign_uploaded_uk_consent_form(uam.reference, rid)

    uam.uk_parental_consent_file_upload_rid = rid
    uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

    # UA
    ua_file_path = @storage.download(uam.ukraine_parental_consent_saved_filename)
    ua_rid = @uploader.upload(ua_file_path, uam.ukraine_parental_consent_filename)
    @foundry.assign_uploaded_ukraine_consent_form(uam.reference, ua_rid)

    uam.ukraine_parental_consent_file_upload_rid = ua_rid
    uam.ukraine_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

    uam.save!(validate: false)
  rescue StandardError => e
    Rails.logger.error "Error uploading consent forms. #{e.message}"
    raise e
  end
end
