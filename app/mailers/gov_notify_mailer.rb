class GovNotifyMailer < GovukNotifyRails::Mailer
  def send_email(email, template_id, personalisation = {})
    set_template(template_id)

    set_personalisation(personalisation)

    mail(to: email)
  end
end
