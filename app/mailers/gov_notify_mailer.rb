class GovNotifyMailer < GovukNotifyRails::Mailer
  def send_individual_confirmation_email(application)
    set_template(ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"])

    #TODO: use name
    set_personalisation(
        fullname: "Bob Jones",
        reference: application.reference
    )

    #TODO: use email address
    mail(to: "grant.mckenna@madetech.com")
  end
end
