class EoiController < ApplicationController
  before_action :check_feature_flag

  def index; end

  # somebigchangeformergecheck

  def property_suitable
    render "eoi/steps/is_your_property_suitable"
  end

  def challenges
    render "eoi/steps/challenges"
  end

  def other_ways_to_help
    render "eoi/steps/other_ways_to_help"
  end

  def can_you_commit
    render "eoi/steps/can_you_commit"
  end

  def choose_country
    if ENV["FEATURE_EOI_CHOOSE_COUNTRY_ENABLED"] == "true"
      render "eoi/steps/choose_country"
    else
      redirect_to "/expression-of-interest/self-assessment/your-info"
    end
  end

  def your_info
    render "eoi/steps/now_we_need_your_info"
  end

  def check_feature_flag
    redirect_to "/404" and return unless ENV["FEATURE_EOI_JOURNEY_ENABLED"] == "true"
  end

  def display
    @application = ExpressionOfInterest.new(session[:eoi])

    # If this new journey is being used, the old journeys (individual and organisation)
    # aren't applicable any more so delete their cookie data to free up some space in the cookie.
    if session[:individual_expression_of_interest]
      session.delete(:individual_expression_of_interest)
    end

    if session[:organisation_expression_of_interest]
      session.delete(:organisation_expression_of_interest)
    end

    step = params["stage"]

    # Check that step is a valid state name.
    if EoiWorkflow.states.key?(step)
      render EoiWorkflow.states[step][:view_name]
    else
      redirect_to "/expression-of-interest/self-assessment/property-suitable"
    end
  end

  def handle_step
    current_stage = params["stage"]
    redirect_to "/404" unless EoiWorkflow.states.key?(current_stage)

    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = ExpressionOfInterest.new(session[:eoi])

    # If its the starting state and not being edited after check-answers
    if EoiWorkflow.states.keys[0] == current_stage && !params.key?("check")
      @application.started_at = Time.zone.now.utc
    end

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    @application.partial_validation = EoiWorkflow.states[current_stage][:validations]
    if @application.valid?
      session[:eoi] = @application.as_json
      next_stage = EoiWorkflow.get_next_step(current_stage, application_params)
      if next_stage == "check-answers" || params.key?("check")
        redirect_to "/expression-of-interest/check-answers"
      else
        redirect_to "/expression-of-interest/steps/#{next_stage}"
      end
    else
      render EoiWorkflow.states[current_stage][:view_name]
    end
  end

  def check_answers
    @application = ExpressionOfInterest.new(session[:eoi])
    @application.partial_validation = [:full_validation]
    @application.valid?
    render "check_answers"
  end

  def submit
    @application = ExpressionOfInterest.new(session[:eoi])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent

    # Set default answers for skipped questions
    @application.more_properties = "no" if @application.different_address == "no"
    @application.property_one_line_1 = "same as main residence" if @application.different_address == "no"
    @application.property_one_town = "same as main residence" if @application.different_address == "no"
    @application.property_one_postcode = @application.residential_postcode if @application.different_address == "no"

    @application.partial_validation = [:full_validation]
    if @application.valid?
      @application.save!
      session[:app_reference] = @application.reference
      session[:eoi] = {}
      SendEoiUpdateJob.perform_later(@application.id)
      GovNotifyMailer.send_expression_of_interest_confirmation_email(@application).deliver_later
      redirect_to "/expression-of-interest/confirm"
    else
      render "check_answers"
    end
  end

  def confirm
    @app_reference = session[:app_reference]
  end

private

  def application_params
    params.require(:expression_of_interest)
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
          :more_properties_statement,
          :number_adults,
          :number_children,
          :family_type,
          :accommodation_length,
          :host_as_soon_as_possible,
          :hosting_start_date,
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
