require "notifications/client"

class GovNotifyMailer
  def self.notify_client
    Notifications::Client.new("ukrainianrefugeesponsorshipschemetest-e8fd0b83-9213-4a38-8632-7a461ad7f71e-1a682262-b4cd-4019-9f2c-4d2ed92453a1")
  end

  def send_email(email, template_id, personalisation = {})
    notify_client.send_email(
        email_address: email,
        template_id: template_id,
        personalisation: personalisation,
        )
  end
end
