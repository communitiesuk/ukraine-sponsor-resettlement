class AbstractCookiesAccept
  include ActiveModel::Model

  attr_accessor :cookies_accepted

  validates :cookies_accepted, acceptance: { message: "You must select an option" }
end
