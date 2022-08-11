require "net/http"

class TransferConsents
  def initialize; end

  def self.execute_unaccompanied_minor_consent_forms(record_id, storage_service = nil, upload_service = nil, foundry = nil)
    Rails.logger.info "Uploading consent forms for record: #{record_id}"

    storage_service ||= StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    upload_service ||= FileUploadService.new
    foundry ||= FoundryService.new

    begin
      uam = UnaccompaniedMinor.find(record_id)

      # UK
      file_path = storage_service.download(uam.uk_parental_consent_saved_filename)
      rid = upload_service.upload(file_path, uam.uk_parental_consent_filename)
      foundry.assign_uploaded_uk_consent_form(uam.reference, rid)

      uam.uk_parental_consent_file_upload_rid = rid
      uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

      # UA
      ua_file_path = storage_service.download(uam.ukraine_parental_consent_saved_filename)
      ua_rid = upload_service.upload(ua_file_path, uam.ukraine_parental_consent_filename)
      foundry.assign_uploaded_ukraine_consent_form(uam.reference, ua_rid)

      uam.ukraine_parental_consent_file_upload_rid = ua_rid
      uam.ukraine_parental_consent_file_uploaded_timestamp = Time.zone.now.utc

      uam.save!(validate: false)
    rescue StandardError => e
      Rails.logger.error "Error uploading consent forms. #{e.message}"
      raise e
    end
  end

  def self.execute_unaccompanied_minor_uk_consent(record_id)
    Rails.logger.info "Uploading uk consent for record: #{record_id}"
  end

  def self.execute_unaccompanied_minor_ukraine_consent(record_id)
    Rails.logger.info "Uploading ukraine consent for record: #{record_id}"

    # @application.ukraine_parental_consent_file_type
    # @application.ukraine_parental_consent_filename
    # @application.ukraine_parental_consent_saved_filename
    # @application.ukraine_parental_consent_file_size
  end
end
