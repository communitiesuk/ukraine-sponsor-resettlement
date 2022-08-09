class SendUnaccompaniedMinorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for unaccompanied minor #{id}"
    TransferRecord.execute_unaccompanied_minor(id)

    if ENV["FEATURE_TRANSFER_CONSENT_FORMS"] == "true"
      TransferRecord.execute_unaccompanied_minor_consent_forms(id)
    end
  end
end
