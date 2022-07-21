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

  def send_save_and_return_email(given_name, link, email)
    set_template(ENV["856b0664-1f96-463c-8acd-c4ef782cdcad"])

    set_personalisation(given_name:, save_and_return_link: link)

    mail(to: email)
  end
end
