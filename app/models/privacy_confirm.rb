class PrivacyConfirm
  include ActiveModel::Model
  
  attr_accessor :privacy_statement_confirm
  
  validates :privacy_statement_confirm, acceptance: { message: "You must read and agree to the privacy statement to continue" }
end
  