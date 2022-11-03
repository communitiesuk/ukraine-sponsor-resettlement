class EoiController < ApplicationController
  MAX_STEPS = 16
  MIN_ENTRY_DIGITS = 3
  MAX_ENTRY_DIGITS = 128
  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  before_action :check_feature_flag

  def index; end

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

    step = params["stage"].to_i

    if (1..MAX_STEPS).cover?(step)
      render path_for_step
    else
      redirect_to "/expression-of-interest/self-assessment/start"
    end
  end

  def handle_step
    current_stage = params["stage"].to_i
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = ExpressionOfInterest.new(session[:eoi])
    @application.started_at = Time.zone.now.utc if current_stage == 1
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    step_validations_map = {
      1 => [:fullname],
      2 => [:email],
      3 => [:phone_number],
      4 => %i[residential_line_1 residential_line_2 residential_town residential_postcode],
      5 => [:different_address],
      6 => %i[property_one_line_1 property_one_line_2 property_one_town property_one_postcode],
      7 => [:more_properties],
      8 => [],
      9 => %i[host_as_soon_as_possible hosting_start_date],
      10 => %i[number_adults number_children],
      11 => [:family_type],
      12 => %i[single_room_count double_room_count],
      13 => [:step_free],
      14 => [:allow_pet],
      15 => [:user_research],
      16 => [:agree_privacy_statement],
    }

    @application.partial_validation = step_validations_map[current_stage]
    if @application.valid?
      # Update the session
      session[:eoi] = @application.as_json
      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_eoi_step(@application, current_stage)

      if next_stage > MAX_STEPS || params.key?("check")
        redirect_to "/expression-of-interest/check-answers"
      else
        redirect_to "/expression-of-interest/steps/#{next_stage}"
      end
    else
      render path_for_step
    end
  end

  def check_answers
    @application = ExpressionOfInterest.new(session[:eoi])
    @application.partial_validation = []
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

    @application.partial_validation = []
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

  def path_for_step(to_step = nil)
    step = to_step || params["stage"].to_i
    "eoi/steps/#{step}"
  end

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
