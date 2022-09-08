class FoundryConsentUploadController < ApplicationController
  add_flash_types :error

  unless Rails.env.test?
    http_basic_authenticate_with name: ENV.fetch("CONSENT_UPLOAD_USER"), password: ENV.fetch("CONSENT_UPLOAD_PASS")
  end

  def display
    render "foundry_consent_upload/form"
  end

  def form
    begin
      uam = UnaccompaniedMinor.find_by_reference(params["consent"]["reference"])
      consent_uploader = TransferConsents.new
      consent_uploader.send(uam.id)
    rescue StandardError => e
      Rails.logger.debug "****************************************************************"
      Rails.logger.debug "Test upload errors: #{e.message}"
      Rails.logger.debug "****************************************************************"
      flash[:error] = e.message
    end

    render "foundry_consent_upload/form"
  end

private

  def permitted_params
    params.permit(:reference)
  end
end
