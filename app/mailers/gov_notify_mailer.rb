class GovNotifyMailer < GovukNotifyRails::Mailer
  def send_individual_confirmation_email(application)
    set_template(ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email) if valid_email?(application.email)
  end

  def send_organisation_confirmation_email(application)
    set_template(ENV["ORGANISATION_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email) if valid_email?(application.email)
  end

  def valid_email?(emailAddress)
    emailAddress.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
  end
end
