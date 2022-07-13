class AbstractConfirm
  include ActiveModel::Model

  attr_accessor :confirm_and_continue
 
  validates :confirm_and_continue, acceptance: { message: "You must confirm to continue" }
 
end
