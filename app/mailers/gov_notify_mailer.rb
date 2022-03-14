require "notifications/client"

class GovNotifyMailer
  def self.notify_client
    Notifications::Client.new(ENV["GOVUK_NOTIFY_API_KEY"])
  end

  def send_email(email, template_id, personalisation = {})
    notify_client.send_email(
        email_address: email,
        template_id: template_id,
        personalisation: personalisation,
        )
  end
end
