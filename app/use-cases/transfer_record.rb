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

    uam = UnaccompaniedMinor.find(record_id)
    file_path = storage_service.download(uam.uk_parental_consent_saved_filename)
    rid = upload_service.upload(file_path)
    foundry.assign_uploaded_uk_consent_form(uam.reference, rid)

    uam.uk_parental_consent_file_upload_rid = rid
    # uam.uk_parental_consent_file_uploaded_timestamp = Time.zone.now.utc
    # uam.save!(validate: false)

    # update rid in uam model and datetime

    # self.execute_unaccompanied_minor_uk_consent(record_id)
    # self.execute_unaccompanied_minor_ukraine_consent(record_id)
  end

  def self.execute_unaccompanied_minor_uk_consent(record_id)
    Rails.logger.info "Uploading uk consent for record: #{record_id}"
    # TODO
    # Get uam record to find s3 object id

    # @application.uk_parental_consent_file_type
    # @application.uk_parental_consent_filename
    # @application.uk_parental_consent_saved_filename
    # @application.uk_parental_consent_file_size

    # download s3 file
    # upload to foundry and grab rid (see ticket)
    # update rid in uam model and datetime
    # call cloudfoundry to associatte the upload with the application!
  end

  def self.execute_unaccompanied_minor_ukraine_consent(record_id)
    Rails.logger.info "Uploading ukraine consent for record: #{record_id}"

    # TODO
    # Get uam record to find s3 object id

    # @application.ukraine_parental_consent_file_type
    # @application.ukraine_parental_consent_filename
    # @application.ukraine_parental_consent_saved_filename
    # @application.ukraine_parental_consent_file_size

    # download s3 file
    # upload to foundry and grab rid
    # call cloudfoundry to associatte the upload with the application!
    # update rid in uam model and datetime
  end
end

class FileUploadService
  def upload(_file_path)
    raise "Not implemented yet"
  end
end

class FoundryService
  def assign_uploaded_uk_consent_form(_uam_reference, _rid)
    raise "Not implemented yet"
  end
end
