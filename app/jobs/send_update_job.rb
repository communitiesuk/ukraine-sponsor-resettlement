class SendUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for application #{id}"
    TransferRecord.execute(id)
  end
end
