class TokenBasedResumeController < ApplicationController
  require "notifications/client"

  add_flash_types :error

  def session_expired
    send_email
    reset_session
    render "token-based-resume/session_expired"
  end

  def display
    @abstractresumetoken = AbstractResumeToken.new(magic_link: params[:uuid])
    send_token
    render "token-based-resume/session_resume_form"
  end

  def save_return_confirm
    render "token-based-resume/save_return_confirm"
  end

  def save_return
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    if @application.given_name.present? && @application.family_name.present? && @application.email.present? && @application.phone_number.present?
      # if we have all the user's info, an email with the resume link is sent and the user is presented with a confirmation page
      send_email
      redirect_to "/sponsor-a-child/save-and-return-confirm"
    else
      # not all info are provided, users redirected to fill them in
      redirect_to "/sponsor-a-child/steps/10"
    end
  end

  def save_return_expired
    @application = UnaccompaniedMinor.new

    render "token-based-resume/save_return_expired"
  end

  def resend_link
    email_address = params["unaccompanied_minor"]["email"]

    if email_address.present?
      @application = UnaccompaniedMinor.find_by_email(email_address)

      if @application.nil?
        # No application found
        @application = UnaccompaniedMinor.new
        @application.errors.add(:email, I18n.t(:no_application_found, scope: :error))

        render "token-based-resume/save_return_expired"
      end

    else
      @application = UnaccompaniedMinor.new
      @application.errors.add(:email, I18n.t(:invalid_email, scope: :error))

      render "sponsor-a-child/save_return_expired"
    end
  end

  def submit
    @abstractresumetoken = AbstractResumeToken.new(magic_link: params[:uuid])
    @abstractresumetoken.assign_attributes(confirm_params)

    if @abstractresumetoken.valid?
      Rails.logger.debug @abstractresumetoken
      @applicationtoken = ApplicationToken.find_by(magic_link: @abstractresumetoken.magic_link, token: @abstractresumetoken.token)
      Rails.logger.debug @applicationtoken
      if @applicationtoken.present?
        if Time.zone.now.utc <= @applicationtoken.expires_at
          # the application exists, store in the session and let them resume
          @application = @applicationtoken.unaccompanied_minor
          session[:app_reference] = @application.reference
          session[:unaccompanied_minor] = @application.as_json

          render "sponsor-a-child/task_list"
        else
          # token has timed out
          flash[:error] = "This code has timed out, please request a new one"
          redirect_to "/sponsor-a-child/resume-application?uuid=#{params[:uuid]}"
        end
      else
        # no application was found with this token
        flash[:error] = "No application found for this code"
        redirect_to "/sponsor-a-child/resume-application?uuid=#{params[:uuid]}"
      end
    else
      # the token is invalid
      flash[:error] = "Please enter a valid code"
      render "token-based-resume/session_resume_form"
    end
  end

private

  def confirm_params
    params.require(:abstract_resume_token).permit(:token, :magic_link)
  end

  def generate_magic_link(uuid)
    base_url = url_for(action: "display", controller: "token_based_resume", only_path: false)
    "#{base_url}?uuid=#{uuid}"
  end

  def generate_token
    Array.new(6) { rand(10) }.join
  end

  def generate_application_token(application, magic_link)
    application_token = ApplicationToken.new(
      unaccompanied_minor: application,
      magic_link:,
      token: generate_token,
      expires_at: Time.zone.now.utc + 20.minutes,
    )
    application_token.save!
  end

  def send_email
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    personal_uuid = SecureRandom.uuid
    return_link = generate_magic_link(personal_uuid)
    generate_application_token(@application, personal_uuid)

    GovNotifyMailer.send_save_and_return_email(@application.given_name, return_link, @application.email).deliver_later
  end

  def send_token
    sms_api = ENV["GOVUK_NOTIFY_SMS_API_KEY"]

    @texter = Notifications::Client.new(sms_api)

    @application_reference = ApplicationToken.find_by(magic_link: params[:uuid])
    sms_token = @application_reference.token
    number = @application_reference.unaccompanied_minor.phone_number
    @texter.send_sms(phone_number: number, template_id: "b51a151e-f352-473a-b52e-185d2873cbf5", personalisation: { OTP: sms_token })
  end
end
