class SendAdditionalInfoUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for additional information #{id}"
    TransferRecord.execute_additional_info(id)
  end
end
