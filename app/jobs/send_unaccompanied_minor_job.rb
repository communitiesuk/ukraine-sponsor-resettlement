class SendUnaccompaniedMinorJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for unaccompanied minor #{id}"
    TransferRecord.execute_unaccompanied_minor(id)

    # Uploading files
    TransferRecord.execute_unaccompanied_minor_consent_forms(id)
    # TransferRecord.execute_unaccompanied_minor_uk_consent(id)
    # TransferRecord.execute_unaccompanied_minor_ukraine_consent(id)
  end
end
