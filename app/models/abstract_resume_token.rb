class AbstractResumeToken
  include ActiveModel::Model

  attr_accessor :token

  validates :token, presence: { message: "The code is required" },
                    numericality: { message: "You must insert a valid 6-digit code" }
end
