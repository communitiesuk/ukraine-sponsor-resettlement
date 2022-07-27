class AbstractResumeToken
  include ActiveModel::Model

  attr_accessor :token, :magic_link

  validates :token, presence: { message: "The code is required" },
                    numericality: { message: "You must insert a valid 6-digit code" }
end
