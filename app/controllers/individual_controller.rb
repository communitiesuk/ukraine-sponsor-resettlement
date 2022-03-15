class IndividualController < ApplicationController
  def display
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])

    render "individual/steps/#{params['stage']}"
  end

  def handle_step
    max_steps = 12
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    p @application

    if @application.valid?
      # Update the session
      session[:individual_expression_of_interest] = @application.as_json
      next_stage = params["stage"].to_i + 1
      if next_stage > max_steps
        redirect_to "/individual/check_answers"
      else
        redirect_to "/individual/steps/#{next_stage}"
      end
    else
      render "individual/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
  end

  def submit
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.save!

    session[:app_reference] = @application.reference
    session[:individual_expression_of_interest] = {}

    SendIndividualUpdateJob.perform_later(@application.id)
    GovNotifyMailer.send_individual_confirmation_email(@application).deliver_later
    redirect_to "/individual/confirm"
  end

  def confirm
    @app_reference = session[:app_reference]
  end

private

  def application_params
    params.require(:individual_expression_of_interest).permit(:family_type, :step_free, :single_room_count,
                                                              :double_room_count, :postcode, :accommodation_length,
                                                              :answer_more_questions_type, :fullname, :email,
                                                              :phone_number, :reference, :agree_privacy_statement,
                                                              :agree_future_contact, :living_space => [])
  end
end
