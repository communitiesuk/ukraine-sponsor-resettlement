class TokenBasedResumeController < ApplicationController
  
    def session_expired
        render 'token-based-resume/session_expired'
    end
  
    def display
        render 'token-based-resume/session_resume_form'
    end
  
    def submit
      @applicationtoken = ApplicationToken.find_by_reference(params[:code])

      if @applicationtoken?
        @application = @applicationtoken.unaccompanied_minor
        session[:app_reference] = @application.reference
        session[:unaccompanied_minor] = @application.as_json
  
        redirect_to 'sponsor-a-child/task_list'
      else
        render 'token-based-resume/session_resume_form'
      end
    end
  end
  