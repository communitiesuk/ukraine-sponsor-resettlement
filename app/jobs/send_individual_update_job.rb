class SendIndividualUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for application #{id}"
    TransferRecord.execute_individual(id)
  end
end
