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

    if current_stage == 9 # hosting_start_date
      if params["expression_of_interest"]["host_as_soon_as_possible"] != "true"
        begin
          hosting_start_date = Date.new(params["expression_of_interest"]["hosting_start_date(1i)"].to_i, params["expression_of_interest"]["hosting_start_date(2i)"].to_i, params["expression_of_interest"]["hosting_start_date(3i)"].to_i)

          if hosting_start_date < Time.zone.today
            @application.errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
            render path_for_step and return
          end
        rescue Date::Error
          @application.errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
          render path_for_step and return
        end
      else
        params["expression_of_interest"]["hosting_start_date(1i)"] = ""
        params["expression_of_interest"]["hosting_start_date(2i)"] = ""
        params["expression_of_interest"]["hosting_start_date(3i)"] = ""
        @application.hosting_start_date = nil
      end
    end

    if current_stage == 6 # different_address address form
      if params["expression_of_interest"]["property_one_line_1"].nil? || params["expression_of_interest"]["property_one_line_1"].strip.length < MIN_ENTRY_DIGITS || params["expression_of_interest"]["property_one_line_1"].strip.length > MAX_ENTRY_DIGITS
        @application.errors.add(:property_one_line_1, I18n.t(:address_line_1, scope: :error))
      end

      if params["expression_of_interest"]["property_one_line_2"].present? && params["expression_of_interest"]["property_one_line_2"].strip.length > MAX_ENTRY_DIGITS
        @application.errors.add(:property_one_line_2, I18n.t(:address_line_2, scope: :error))
      end

      if params["expression_of_interest"]["property_one_town"].nil? || params["expression_of_interest"]["property_one_town"].strip.length < MIN_ENTRY_DIGITS || params["expression_of_interest"]["property_one_town"].strip.length > MAX_ENTRY_DIGITS
        @application.errors.add(:property_one_town, I18n.t(:address_town, scope: :error))
      end

      if params["expression_of_interest"]["property_one_postcode"].nil? || params["expression_of_interest"]["property_one_postcode"].strip.length < MIN_ENTRY_DIGITS || params["expression_of_interest"]["property_one_postcode"].strip.length > MAX_ENTRY_DIGITS || !params["expression_of_interest"]["property_one_postcode"].match(POSTCODE_REGEX)
        @application.errors.add(:property_one_postcode, I18n.t(:address_postcode, scope: :error))
      end

      if @application.errors.any?
        render path_for_step and return
      end
    end

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
    @application.hosting_start_date_as_string = if @application.host_as_soon_as_possible == "true"
                                                  "As soon as possible"
                                                else
                                                  Date.new(
                                                    @application.hosting_start_date["1"].to_i,
                                                    @application.hosting_start_date["2"].to_i,
                                                    @application.hosting_start_date["3"].to_i,
                                                  ).strftime("%d %B %Y")
                                                end
  end

  def submit
    @application = ExpressionOfInterest.new(session[:eoi])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.final_submission = true
    @application.hosting_start_date_as_string = if @application.host_as_soon_as_possible == "true"
                                                  "As soon as possible"
                                                else
                                                  Date.new(
                                                    @application.hosting_start_date["1"].to_i,
                                                    @application.hosting_start_date["2"].to_i,
                                                    @application.hosting_start_date["3"].to_i,
                                                  ).strftime("%d %B %Y")
                                                end
    # Set default answers for skipped questions
    @application.more_properties = "no" if @application.more_properties.blank?
    @application.property_one_line_1 = "same as main residence" if @application.property_one_line_1.blank?
    @application.property_one_town = "same as main residence" if @application.property_one_town.blank?
    @application.property_one_postcode = @application.residential_postcode if @application.property_one_postcode.blank?

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
