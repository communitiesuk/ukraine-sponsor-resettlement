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
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
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
    Rails.logger.debug session[:organisation_expression_of_interest]
  end

  def submit
    @application = OrganisationExpressionOfInterest.new(session[:organisation_expression_of_interest])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.final_submission = true
    if @application.valid?
      @application.save!

      session[:app_reference] = @application.reference
      session[:organisation_expression_of_interest] = {}

      SendOrganisationUpdateJob.perform_later(@application.id)
      GovNotifyMailer.send_organisation_confirmation_email(@application).deliver_later
      redirect_to "/organisation/confirm"
    else
      render "check_answers"
    end
  end

  def confirm
    @app_reference = session[:app_reference]
  end

private

  def application_params
    params.require(:organisation_expression_of_interest).permit(:family_type, :step_free, :property_count, :single_room_count, :double_room_count, :postcode, :organisation_name, :organisation_type, :agree_future_contact, :fullname, :email, :phone_number, :agree_privacy_statement, :organisation_type_business_information, :organisation_type_other_information, living_space: [])
  end
end
