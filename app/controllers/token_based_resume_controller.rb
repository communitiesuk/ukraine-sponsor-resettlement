class TokenBasedResumeController < ApplicationController
  add_flash_types :error
  ## skip_after_action :update_session_last_seen

  def session_expired
    send_email
    ##  session_reset
    render "token-based-resume/session_expired"
  end

  def display
    @abstractresumetoken = AbstractResumeToken.new(magic_link: params[:uuid])
    render "token-based-resume/session_resume_form"
  end

  def submit
    @abstractresumetoken = AbstractResumeToken.new(magic_link: params[:uuid])
    @abstractresumetoken.assign_attributes(confirm_params)

    if @abstractresumetoken.valid?
      @applicationtoken = ApplicationToken.find_by(magic_link: @abstractresumetoken.magic_link, token: @abstractresumetoken.token)

      if @applicationtoken.present?
        # the application exists, store in the session and let them resume
        @application = @applicationtoken.unaccompanied_minor
        session[:app_reference] = @application.reference
        session[:unaccompanied_minor] = @application.as_json

        render "sponsor-a-child/task_list"
      else
        # no application was found with this token
        flash[:error] = "No application found for this code"
        redirect_to "/sponsor-a-child/resume-application?uuid=#{params[:uuid]}"
      end
    else
      # the token is invalid
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
    )
    application_token.save!
  end

  def send_email
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    personal_uuid = SecureRandom.uuid
    return_link = generate_magic_link(personal_uuid)
    generate_application_token(@application, personal_uuid)
    GovNotifyMailer.send_save_and_return_email(@application.email, @application.given_name, return_link).deliver_later
  end
end
