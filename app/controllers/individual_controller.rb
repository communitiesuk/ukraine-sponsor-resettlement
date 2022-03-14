class IndividualController < ApplicationController
  def display
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])

    render "individual/steps/#{params['stage']}"
  end

  def handle_step
    max_steps = 13
    # Pull session data out of session and
    # instantiate new Application AactiveRecord object
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

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
    @application.save!
    SendUpdateJob.perform_later(@application.id)
    redirect_to "/individual/confirm"
  end

  def confirm
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
  end

private

  def application_params
    params.require(:individual_expression_of_interest).permit(:sponsor_type, :family_or_single_type, :living_space_type,
                                                              :mobility_impairments_type, :single_room_count, :double_room_count, :postcode,
                                                              :accommodation_length_type, :dbs_certificate_type, :answer_more_questions_type,
                                                              :fullname, :email, :mobile_number)
  end
end
