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
    if @application.given_name.blank? || @application.family_name.blank?
      # name not provided, redirect to name filling form page
      redirect_to "/sponsor-a-child/steps/10"
    elsif @application.email.blank? || @application.phone_number.blank?
      # phone or email not provided, redirect to phone filling form page
      redirect_to "/sponsor-a-child/steps/14"
    else
      session[:sent_to_email] = scramble_email(@application.email)
      send_email
      redirect_to "/sponsor-a-child/save-and-return/confirm"
    end
  end

  def save_return_resend_link_form
    @application = UnaccompaniedMinor.new

    render "token-based-resume/save_return_resend_link"
  end

  def resend_link
    email_address = params["unaccompanied_minor"]["email"]

    if email_address.present?
      @application = UnaccompaniedMinor.where("answers ->> 'email' = '#{email_address}'").first

      if @application.nil?
        # No application found
        @application = UnaccompaniedMinor.new
        @application.errors.add(:email, I18n.t(:no_application_found, scope: :error))

        render "token-based-resume/save_return_resend_link"
      else
        # Happy path
        session[:app_reference] = @application.reference
        session[:sent_to_email] = scramble_email(email_address)
        send_email
        redirect_to "/sponsor-a-child/save-and-return/confirm"
      end
    else
      @application = UnaccompaniedMinor.new
      @application.errors.add(:email, I18n.t(:invalid_email, scope: :error))

      render "token-based-resume/save_return_resend_link"
    end
  end

  def submit
    @abstractresumetoken = AbstractResumeToken.new(magic_link: params[:uuid])
    @abstractresumetoken.assign_attributes(confirm_params)

    if @abstractresumetoken.valid?
      @applicationtoken = ApplicationToken.find_by(magic_link: @abstractresumetoken.magic_link, token: @abstractresumetoken.token)
      if @applicationtoken.present?
        if Time.zone.now.utc <= @applicationtoken.expires_at

          puts @applicationtoken.unaccompanied_minor.as_json
          # check if user has more than one application
          mail = @applicationtoken.unaccompanied_minor.email
          num = @applicationtoken.unaccompanied_minor.phone_number
          p mail
          p num

          applications = UnaccompaniedMinor.where(
            # email: mail
            #"email = '#{mail}'",

            # "answers ->> 'email' = '#{@applicationtoken.unaccompanied_minor.email}'",
            "answers ->> 'phone_number' = '#{num}'",
          )

          p applications.size

          applications.each do |app|
            puts app.as_json
          end

          if applications.size > 1
            @applications = applications
            render "token-based-resume/select_multiple_applications"
          elsif applications.size == 1
            @application = @applicationtoken.unaccompanied_minor
            session[:app_reference] = @application.reference
            session[:unaccompanied_minor] = @application.as_json

            render "sponsor-a-child/task_list"
            # the application exists, store in the session and let them resume
          else
            # no application was found with this token
            flash[:error] = "No application found for this code"
            redirect_to "/sponsor-a-child/resume-application?uuid=#{params[:uuid]}"
          end
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

  def select_multiple_applications
    selected_application = nil
    if selected_application
      @application = UnaccompaniedMinor.find_by(reference: selected_application)
      session[:app_reference] = selected_application
      session[:unaccompanied_minor] = @application.as_json

      render "sponsor-a-child/task_list"
    else
      render "token-based-resume/select_multiple_applications"
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
    @application_token = ApplicationToken.find_by(unaccompanied_minor: @application)

    if @application_token.present? && Time.zone.now.utc >= (@application_token.created_at + 1.day)
      # only resend the same link if the application_token has been requested less than a day ago
      return_link = @application_token.magic_link
    else
      personal_uuid = SecureRandom.uuid
      return_link = generate_magic_link(personal_uuid)
      generate_application_token(@application, personal_uuid)
    end
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

  def scramble_email(email)
    email_parts = email.split("@")
    email_scrambled = (email_parts[0][0]).to_s + "*" * (email_parts[0].length - 1)
    "#{email_scrambled}@#{email_parts[1]}"
  end
end
