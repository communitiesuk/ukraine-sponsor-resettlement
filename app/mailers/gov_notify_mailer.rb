class GovNotifyMailer < ActionMailer::Base
  def notify_client
    @notify_client ||= ::Notifications::Client.new(ENV["GOVUK_NOTIFY_API_KEY"])
  end
end
