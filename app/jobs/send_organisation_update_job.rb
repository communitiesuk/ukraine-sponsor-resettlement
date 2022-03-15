class SendOrganisationUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for organisation expression of interest #{id}"
    TransferRecord.execute_organisation(id)
  end
end
