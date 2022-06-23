class GovNotifyMailer < GovukNotifyRails::Mailer
  def send_individual_confirmation_email(application)
    set_template(ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email)
  end

  def send_organisation_confirmation_email(application)
    set_template(ENV["ORGANISATION_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email)
  end

  def send_additional_info_confirmation_email(application)
    set_template(ENV["ADDITIONAL_INFO_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email)
  end

  def send_unaccompanied_minor_confirmation_email(application)
    set_template(ENV["SPONSOR_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    mail(to: application.email)
  end
end
