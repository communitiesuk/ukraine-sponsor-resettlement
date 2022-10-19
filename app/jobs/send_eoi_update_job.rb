class SendExpressionOfInterestUpdateJob < ApplicationJob
  queue_as :default

  def perform(id)
    Rails.logger.info "Sending update for expression of interest #{id}"
    TransferRecord.execute_expression_of_interest(id)
  end
end
