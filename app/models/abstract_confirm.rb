class AbstractConfirm
  include ActiveModel::Model

  attr_accessor :confirm_and_continue, :privacy_statement_confirm

  validates :confirm_and_continue, acceptance: { message: "You must confirm to continue" }
  validates :privacy_statement_confirm, acceptance: { message: "You must read and agree to the privacy statement to continue" }
end
