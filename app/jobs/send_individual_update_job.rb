class SendIndividualUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for individual expression of interest #{id}"
    TransferRecord.execute_individual(id)
  end
end
