class SendUnaccompaniedMinorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for unaccompanied minor #{id}"
    TransferRecord.execute_unaccompanied_minor(id)

    if ENV["UAM_FEATURE_TRANSFER_CONSENT_FORMS"] == "true"
      consent_uploader = TransferConsents.new
      consent_uploader.send(id)
    end
  end
end
