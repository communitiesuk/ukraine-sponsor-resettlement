class TokenBasedResumeController < ApplicationController
  add_flash_types :error

  def session_expired
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
end
