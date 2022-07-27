class TokenBasedResumeController < ApplicationController
  add_flash_types :error
  ## skip_after_action :update_session_last_seen

  def session_expired
  ##  send_email
  ##  session_reset
    render "token-based-resume/session_expired"
  end

  def display
    @abstractresumetoken = AbstractResumeToken.new
    render "token-based-resume/session_resume_form"
  end

  def submit
    @abstractresumetoken = AbstractResumeToken.new
    @abstractresumetoken.assign_attributes(confirm_params)

    if @abstractresumetoken.valid?
      @applicationtoken = ApplicationToken.find_by(token: @abstractresumetoken.token)

      if @applicationtoken.present?
        # the application exists, store in the session and let them resume
        @application = @applicationtoken.unaccompanied_minor
        session[:app_reference] = @application.reference
        session[:unaccompanied_minor] = @application.as_json

        render "sponsor-a-child/task_list"
      else
        # no application was found with this token
        flash[:error] = "No application found for this code"
        redirect_to "/sponsor-a-child/resume-application"
      end
    else
      # the token is invalid
      render "token-based-resume/session_resume_form"
    end
  end

private

  def confirm_params
    params.require(:abstract_resume_token).permit(:token)
  end

  ##def send_email
  ##  @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
  ##  return_link = url_for(:action => 'display', :controller => 'token_based_resume_controller', :only_path => false)
  ##  GovNotifyMailer.send_save_and_return_email(@application.email, @application.given_name, return_link).deliver_later
  ##end
##
  ##def create_and_send_code
  ##  @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
  ##  generate_code = 6.times.map{rand(10)}.join
  ##  ApplicationToken.new(unaccompanied_minor: application, token: generate_code)
##
##
  ##end

end
