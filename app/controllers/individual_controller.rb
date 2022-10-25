class IndividualController < ApplicationController
  MAX_STEPS = 18
  before_action :check_feature_flag

  def check_feature_flag
    if ENV["FEATURE_EOI_JOURNEY_ENABLED"] == "true" && !(Rails.env = "test")
      redirect_to "/expression-of-interest"
    end
  end

  def display
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])

    step = params["stage"].to_i

    if (1..MAX_STEPS).cover?(step)
      render path_for_step
    else
      redirect_to "/individual"
    end
  end

  def handle_step
    current_stage = params["stage"].to_i
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
    @application.started_at = Time.zone.now.utc if current_stage == 1
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the session
      session[:individual_expression_of_interest] = @application.as_json

      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_individual_step(@application, current_stage)

      if next_stage > MAX_STEPS
        redirect_to "/individual/check_answers"
      else
        redirect_to "/individual/steps/#{next_stage}"
      end
    else
      render path_for_step
    end
  end

  def check_answers
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
  end

  def submit
    @application = IndividualExpressionOfInterest.new(session[:individual_expression_of_interest])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.final_submission = true

    # Set default answers for skipped questions
    @application.more_properties = "no" if @application.more_properties.blank?
    @application.property_one_line_1 = "same as main residence" if @application.property_one_line_1.blank?
    @application.property_one_town = "same as main residence" if @application.property_one_town.blank?
    @application.property_one_postcode = @application.residential_postcode if @application.property_one_postcode.blank?

    if @application.valid?
      @application.save!
      session[:app_reference] = @application.reference
      session[:individual_expression_of_interest] = {}

      SendIndividualUpdateJob.perform_later(@application.id)
      GovNotifyMailer.send_individual_confirmation_email(@application).deliver_later
      redirect_to "/individual/confirm"
    else
      render "check_answers"
    end
  end

  def confirm
    @app_reference = session[:app_reference]
  end

private

  def path_for_step(to_step = nil)
    step = to_step || params["stage"].to_i
    "individual/steps/#{step}"
  end

  def application_params
    params.require(:individual_expression_of_interest)
        .permit(
          :reference,
          :fullname,
          :email,
          :phone_number,
          :residential_line_1,
          :residential_line_2,
          :residential_town,
          :residential_postcode,
          :different_address,
          :property_one_line_1,
          :property_one_line_2,
          :property_one_town,
          :property_one_postcode,
          :more_properties,
          :number_adults,
          :number_children,
          :family_type,
          :accommodation_length,
          :single_room_count,
          :double_room_count,
          :step_free,
          :allow_pet,
          :agree_future_contact,
          :user_research,
          :agree_privacy_statement,
        )
  end
end
