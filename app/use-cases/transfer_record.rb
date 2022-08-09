require "net/http"

class TransferRecord
  def initialize; end

  def self.execute_individual(record_id)
    IndividualExpressionOfInterest.transaction do
      application = IndividualExpressionOfInterest.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!

      uri = URI(ENV["REMOTE_API_URL"])
      token = ENV["REMOTE_API_TOKEN"]
      res = Net::HTTP.post(uri, JSON.generate(application.as_json), "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      unless res.code.to_i >= 200 && res.code.to_i < 300
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.execute_organisation(record_id)
    OrganisationExpressionOfInterest.transaction do
      application = OrganisationExpressionOfInterest.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!

      uri = URI(ENV["REMOTE_API_URL"])
      token = ENV["REMOTE_API_TOKEN"]
      res = Net::HTTP.post(uri, JSON.generate(application.as_json), "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      unless res.code.to_i >= 200 && res.code.to_i < 300
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.execute_additional_info(record_id)
    AdditionalInfo.transaction do
      application = AdditionalInfo.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!

      uri = URI(ENV["REMOTE_API_URL"])
      token = ENV["REMOTE_API_TOKEN"]
      res = Net::HTTP.post(uri, JSON.generate(application.as_json), "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      unless res.code.to_i >= 200 && res.code.to_i < 300
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.execute_unaccompanied_minor(record_id)
    UnaccompaniedMinor.transaction do
      application = UnaccompaniedMinor.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!(validate: false)

      uri = URI(ENV["REMOTE_API_URL"])
      token = ENV["REMOTE_API_TOKEN_UAM"]
      res = Net::HTTP.post(uri, JSON.generate(application.as_json), "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      unless res.code.to_i >= 200 && res.code.to_i < 300
        Rails.logger.error "Failed to post record: #{record_id} to: #{uri} res.code: #{res.code}"
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.execute_unaccompanied_minor_consent_forms(record_id, storage_service, upload_service, foundry)
    Rails.logger.info "Uploading consent forms for record: #{record_id}"

    storage_service ||= StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    upload_service ||= FileUploadService.new
    foundry ||= FoundryService.new

    begin
      uam = UnaccompaniedMinor.find(record_id)
      file_path = storage_service.download(uam.uk_parental_consent_saved_filename)
      rid = upload_service.upload(file_path, uam.uk_parental_consent_filename)
      foundry.assign_uploaded_uk_consent_form(uam.reference, rid)

      uam.uk_parental_consent_file_upload_rid = rid
      uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now.utc
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
