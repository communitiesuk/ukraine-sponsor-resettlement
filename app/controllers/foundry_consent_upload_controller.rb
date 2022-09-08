class FoundryConsentUploadController < ApplicationController
  add_flash_types :error

  # Warning: BRITTLE and no automated tests
  # This form is a temporary convenience tool
  # Basic auth in staging is currently set in: ApplicationController
  # Doing it twice doesn't work with different creds!
  if Rails.env.production?
    http_basic_authenticate_with name: ENV.fetch("CONSENT_UPLOAD_USER"), password: ENV.fetch("CONSENT_UPLOAD_PASS")
  end

  def display
    render "foundry_consent_upload/form"
  end

  def form
    uam = UnaccompaniedMinor.find_by_reference(params["consent"]["reference"])
    consent_uploader = TransferConsents.new
    consent_uploader.send(uam.id)
  rescue StandardError => e
    Rails.logger.debug "****************************************************************"
    Rails.logger.debug "Test upload errors: #{e.message}"
    Rails.logger.debug "****************************************************************"
    flash[:error] = e.message
  ensure
    render "foundry_consent_upload/form"
  end

private

  def permitted_params
    params.permit(:reference)
  end
end
