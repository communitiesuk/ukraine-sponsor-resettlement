class SendUnaccompaniedMinorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for unaccompanied minor #{id}"
    TransferRecord.execute_unaccompanied_minor(id)

    consent_uploader = TransferConsents.new
    consent_uploader.send(id)
  end
end
