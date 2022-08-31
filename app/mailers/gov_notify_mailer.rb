class GovNotifyMailer < GovukNotifyRails::Mailer
  def send_individual_confirmation_email(application)
    set_template(ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    send_to(application.email)
  end

  def send_organisation_confirmation_email(application)
    set_template(ENV["ORGANISATION_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    send_to(application.email)
  end

  def send_additional_info_confirmation_email(application)
    set_template(ENV["ADDITIONAL_INFO_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.fullname, reference: application.reference)

    send_to(application.email)
  end

  def send_unaccompanied_minor_confirmation_email(application)
    set_template(ENV["SPONSOR_CONFIRMATION_TEMPLATE_ID"])

    set_personalisation(fullname: application.sponsor_full_name?, reference: application.reference)

    send_to(application.email)
  end

  def send_save_and_return_email(given_name, link, email)
    set_template(ENV["SAVE_AND_RETURN_TEMPLATE_ID"])

    set_personalisation(given_name:, save_and_return_link: link)

    send_to(email)
  end

private

  def send_to(email_address)
    mail(to: email_address)
  rescue Notifications::Client::BadRequestError => e
    if !Rails.env.production? && e.message.include?("Can’t send to this recipient using a team-only API key")
      # ignore
    else
      raise
    end
  end
end
