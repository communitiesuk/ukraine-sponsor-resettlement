class FoundryConsentUploadController < ApplicationController
  add_flash_types :error

  def display
    render "foundry_consent_upload/form"
  end

  def form
    if Rails.env.production?
      render nothing: true, status: :method_not_allowed
    end

    uam = UnaccompaniedMinor.find_by_reference(params["consent"]["reference"])

    begin
      TransferRecord.execute_unaccompanied_minor_consent_forms(uam.id)
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
