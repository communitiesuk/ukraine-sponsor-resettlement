class OrganisationController < ApplicationController
  def display
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])

    render "organisation/steps/#{params['stage']}"
  end

  def handle_step
    max_steps = 14
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the session
      session[:organisation_expression_of_interest] = @application.as_json
      next_stage = params["stage"].to_i + 1
      if next_stage > max_steps
        redirect_to "/organisation/check_answers"
      else
        redirect_to "/organisation/steps/#{next_stage}"
      end
    else
      render "organisation/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])
  end

  def submit
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])
    @application.save!
    SendUpdateJob.perform_later(@application.id)
    redirect_to "/organisation/confirm"
  end

  def confirm
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])
  end

private

  def application_params
    params.require(:organisation_expression_of_interest).permit(:sponsor_type, :living_space, :step_free, :property_count, :single_room_count, :double_room_count, :postcode, :organisation_name, :organisation_type, :answer_more_questions, :fullname, :email, :phone_number, :privacy)
  end
end
