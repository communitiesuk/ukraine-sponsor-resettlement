require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper
  include CommonValidations

  before_action :check_last_activity, only: %i[handle_step display]

  MAX_STEPS = 44
  NOT_ELIGIBLE = [-1, 0].freeze
  SPONSOR_NAME = 10
  SPONSOR_OTHER_NAMES_CHOICE = 11
  SPONSOR_OTHER_NAMES = 12
  SPONSOR_EMAIL = 14
  SPONSOR_PHONE_NUMBER = 15
  SPONSOR_ID_TYPE = 16
  SPONSOR_ID_MISSING_EXPLANATION = 17
  SPONSOR_DATE_OF_BIRTH = 18
  SPONSOR_NATIONALITY = 19
  SPONSOR_OTHER_NATIONALITIES_CHOICE = 20
  SPONSOR_OTHER_NATIONALITY = 21
  ADULTS_AT_ADDRESS = 27
  ADULTS_SUMMARY_PAGE = 28
  ADULT_DATE_OF_BIRTH = 29
  ADULT_NATIONALITY = 30
  ADULT_ID_TYPE_AND_NUMBER = 31
  MINOR_CONTACT_DETAILS = 33
  MINOR_DATE_OF_BIRTH = 34
  NATIONALITY_STEPS = [SPONSOR_NATIONALITY, SPONSOR_OTHER_NATIONALITY, ADULT_NATIONALITY].freeze
  SAVE_AND_RETURN_STEPS = [SPONSOR_EMAIL, SPONSOR_PHONE_NUMBER].freeze
  ADULT_STEPS = [ADULT_DATE_OF_BIRTH, ADULT_NATIONALITY, ADULT_ID_TYPE_AND_NUMBER].freeze
  ADULT_STEPS_ALL = [ADULTS_SUMMARY_PAGE, ADULT_DATE_OF_BIRTH, ADULT_NATIONALITY, ADULT_ID_TYPE_AND_NUMBER].freeze
  TASK_LIST_STEP = 999
  TASK_LIST_URI = "/sponsor-a-child/task-list".freeze

  def start
    render "sponsor-a-child/start"
  end

  def check_if_can_use
    @application = UnaccompaniedMinor.new
    @application.started_at = Time.zone.now.utc
    @application.save!

    # Update the session
    session[:app_reference] = @application.reference

    # mini-check page to show after start and before step 1
    render "sponsor-a-child/check_if_can_use"
  end

  def start_application
    # Redirect to show the task-list
    redirect_to TASK_LIST_URI
  end

  def display
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    step = params["stage"].to_i

    if @application.nil? || (1..MAX_STEPS).exclude?(step)
      redirect_to "/sponsor-a-child" and return
    end

    if ADULT_STEPS_ALL.include?(step) && \
        @application.other_adults_address.present? && \
        (params["key"].blank? || @application.adults_at_address.blank?)
      render "sponsor-a-child/task_list"
      return
    end

    if NATIONALITY_STEPS.include?(step)
      @nationalities = if step == SPONSOR_OTHER_NATIONALITY
                         get_nationalities_as_list(@application.saved_nationalities_as_list)
                       else
                         get_nationalities_as_list
                       end
    end

    if SAVE_AND_RETURN_STEPS.include?(step)
      if request.GET["save"]
        @save_and_return_message = true
        @save = "?save=1"
      else
        @save = ""
      end
    end

    if step == SPONSOR_ID_TYPE
      case @application.identification_type
      when "passport"
        @application.passport_identification_number = @application.identification_number
      when "national_identity_card"
        @application.id_identification_number = @application.identification_number
      when "refugee_travel_document"
        @application.refugee_identification_number = @application.identification_number
      end
    elsif ADULT_STEPS.include?(step)
      if @application.adults_at_address.present?
        Rails.logger.debug "Adult page!"

        # Set properties based on values from hash of adults
        @adult = @application.adults_at_address[params["key"]]

        if @adult["date_of_birth"].present? && @adult["date_of_birth"].length.positive?
          @application.adult_date_of_birth = { 3 => @adult["date_of_birth"]["3"], 2 => @adult["date_of_birth"]["2"], 1 => @adult["date_of_birth"]["1"] }
        end

        adult_nationality = @adult["nationality"]
        adult_id_type_and_number = @adult["id_type_and_number"]

        adult_dob = @adult["date_of_birth"]
        if adult_dob.present? && adult_dob.length.positive?
          @application.adult_date_of_birth = {
            3 => Date.parse(adult_dob).day,
            2 => Date.parse(adult_dob).month,
            1 => Date.parse(adult_dob).year,
          }
        end
        @application.adult_nationality = adult_nationality if adult_nationality.present? && adult_nationality.length.positive?

        if adult_id_type_and_number.present? && adult_id_type_and_number.length.positive?
          id_type_and_number = adult_id_type_and_number.split(" - ")
          @application.adult_identification_type = id_type_and_number[0].to_s
          case id_type_and_number[0].to_s
          when "passport"
            @application.adult_passport_identification_number = id_type_and_number[1].to_s
          when "national_identity_card"
            @application.adult_id_identification_number = id_type_and_number[1].to_s
          when "refugee_travel_document"
            @application.adult_refugee_identification_number = id_type_and_number[1].to_s
          end
        end
      end
    end

    render_current_step
  end

  def handle_upload_uk
    current_stage = params["stage"].to_i
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_stage == 1
    @application.uk_parental_consent_filename = ""

    begin
      upload_params = params.require("unaccompanied_minor")["uk_parental_consent"]

      @application.uk_parental_consent_file_type = upload_params.content_type
      @application.uk_parental_consent_filename = upload_params.original_filename
      @application.uk_parental_consent_saved_filename = "#{SecureRandom.uuid.upcase}-#{upload_params.original_filename}"
      @application.uk_parental_consent_file_size = upload_params.size
    rescue ActionController::ParameterMissing
      # Do nothing!
      Rails.logger.debug "No upload file found!"
    end
    @application.partial_validation = %i[uk_parental_consent_file_type uk_parental_consent_filename uk_parental_consent_saved_filename uk_parental_consent_file_size]
    if @application.valid?
      save_and_redirect(@application.uk_parental_consent_saved_filename, upload_params.tempfile)
    else
      render_current_step
    end
  end

  def handle_upload_ukraine
    current_stage = params["stage"].to_i
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_stage == 1
    @application.ukraine_parental_consent_filename = ""

    begin
      upload_params = params.require("unaccompanied_minor")["ukraine_parental_consent"]

      @application.ukraine_parental_consent_file_type = upload_params.content_type
      @application.ukraine_parental_consent_filename = upload_params.original_filename
      @application.ukraine_parental_consent_saved_filename = "#{SecureRandom.uuid.upcase}-#{upload_params.original_filename}"
      @application.ukraine_parental_consent_file_size = upload_params.size
    rescue ActionController::ParameterMissing
      # Do nothing!
      Rails.logger.debug "No upload file found!"
    end
    @application.partial_validation = %i[ukraine_parental_consent_file_type ukraine_parental_consent_filename ukraine_parental_consent_saved_filename ukraine_parental_consent_file_size]
    if @application.valid?
      save_and_redirect(@application.ukraine_parental_consent_saved_filename, upload_params.tempfile)
    else
      render_current_step
    end
  end

  def handle_step
    current_step = params["stage"].to_i
    current_step.freeze

    # Pull session data out of session and
    # instantiate new or existing Application ActiveRecord object
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_step == 1

    # capture identification document number
    if current_step == SPONSOR_ID_TYPE
      @application.identification_type = if params["unaccompanied_minor"].key?("identification_type")
                                           params["unaccompanied_minor"]["identification_type"]
                                         else
                                           ""
                                         end

      @application.identification_number = case @application.identification_type
                                           when "passport"
                                             params["unaccompanied_minor"]["passport_identification_number"]
                                           when "national_identity_card"
                                             params["unaccompanied_minor"]["id_identification_number"]
                                           when "refugee_travel_document"
                                             params["unaccompanied_minor"]["refugee_identification_number"]
                                           else
                                             ""
                                           end
    end

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    @application.partial_validation = if !application_params.keys.empty? && application_params.keys[0].start_with?("sponsor_date_of_birth")
                                        [:sponsor_date_of_birth]
                                      elsif !application_params.keys.empty? && application_params.keys[0].start_with?("minor_date_of_birth")
                                        [:minor_date_of_birth]
                                      elsif !application_params.keys.empty? && application_params.keys[0].start_with?("adult_date_of_birth")
                                        [:adult_date_of_birth]
                                      elsif application_params.key?("identification_type") || application_params.key?("id_identification_number")
                                        %i[identification_type identification_number]
                                      else
                                        application_params.keys.map(&:to_sym)
                                      end

    if @application.valid?
      if current_step == SPONSOR_OTHER_NAMES
        (@application.other_names ||= []) << [@application.other_given_name.strip, @application.other_family_name.strip]
      end

      if current_step == SPONSOR_OTHER_NATIONALITY
        (@application.other_nationalities ||= []) << [params["unaccompanied_minor"]["other_nationality"]]
      end

      if current_step == ADULT_DATE_OF_BIRTH
        @application.adults_at_address[params["key"]]["date_of_birth"] = Date.new(params["unaccompanied_minor"]["adult_date_of_birth(1i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(2i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(3i)"].to_i)
      end

      if current_step == ADULTS_AT_ADDRESS && !(params["unaccompanied_minor"]["adult_given_name"].empty? && params["unaccompanied_minor"]["adult_family_name"].empty?)
        @application.adults_at_address = {} if @application.adults_at_address.nil?
        @application.adults_at_address.store(SecureRandom.uuid.upcase.to_s, Adult.new(params["unaccompanied_minor"]["adult_given_name"], params["unaccompanied_minor"]["adult_family_name"]))
      end

      if current_step == ADULT_NATIONALITY
        @adult = @application.adults_at_address[params["key"]]
        @adult["nationality"] = params["unaccompanied_minor"]["adult_nationality"]
      end

      if current_step == MINOR_CONTACT_DETAILS
        @application.minor_contact_type = @application.minor_contact_type.reject(&:empty?)
        if @application.minor_contact_type.include?("none")
          @application.minor_email = ""
          @application.minor_email_confirm = ""
          @application.minor_phone_number = ""
          @application.minor_phone_number_confirm = ""
        end
        unless @application.minor_contact_type.include?("telephone")
          @application.minor_phone_number = ""
          @application.minor_phone_number_confirm = ""
        end
        unless @application.minor_contact_type.include?("email")
          @application.minor_email = ""
          @application.minor_email_confirm = ""
        end
      end

      # capture the over 16 year old at address id type and number
      if current_step == ADULT_ID_TYPE_AND_NUMBER
        @adult = @application.adults_at_address[params["key"]]
        id_type = params["unaccompanied_minor"]["adult_identification_type"]
        document_id = nil

        case id_type
        when "passport"
          document_id = params["unaccompanied_minor"]["adult_passport_identification_number"]
        when "national_identity_card"
          document_id = params["unaccompanied_minor"]["adult_id_identification_number"]
        when "refugee_travel_document"
          document_id = params["unaccompanied_minor"]["adult_refugee_identification_number"]
        end

        @adult["id_type_and_number"] = "#{id_type} - #{document_id || '123456789'}"
      end

      # Update the database
      @application.update!(@application.as_json)

      # Special steps if we are in save_and_return territory
      # warning: this overrides the routing engine for steps 10-14-15
      if request.GET["save"]
        case current_step
        when 14
          redirect_to "/sponsor-a-child/steps/15?save=1"
        when 15
          redirect_to "/sponsor-a-child/save-and-return/"
        end
      else
        # Replace with routing engine to get next stage
        next_stage = RoutingEngine.get_next_unaccompanied_minor_step(@application, current_step)
        if NOT_ELIGIBLE.include?(next_stage)
          redirect_to "/sponsor-a-child/non-eligible"
        elsif next_stage == TASK_LIST_STEP
          # Redirect to show the task-list
          redirect_to TASK_LIST_URI
        elsif next_stage > MAX_STEPS
          redirect_to "/sponsor-a-child/check-answers"
        elsif ADULT_STEPS.include?(next_stage)
          redirect_to "/sponsor-a-child/steps/#{next_stage}/#{params['key']}"
        else
          redirect_to "/sponsor-a-child/steps/#{next_stage}"
        end
      end
    else
      # Validation failed. Expose the data needed on the steps that need it.
      if NATIONALITY_STEPS.include?(current_step)
        @nationalities = get_nationalities_as_list(@application.saved_nationalities_as_list)
      end

      if [ADULT_DATE_OF_BIRTH, ADULT_NATIONALITY, ADULT_ID_TYPE_AND_NUMBER].include?(current_step)
        @adult = @application.adults_at_address[params["key"]]
      end
      render_current_step
    end
  end

  def check_answers
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])

    Rails.logger.debug "Check answers JSON: #{@application.as_json}"

    unless @application.sponsor_date_of_birth.nil?
      @application.sponsor_date_of_birth_as_string = format_date_of_birth(@application.sponsor_date_of_birth["1"], @application.sponsor_date_of_birth["2"], @application.sponsor_date_of_birth["3"])
    end
    unless @application.minor_date_of_birth.nil?
      @application.minor_date_of_birth_as_string = format_date_of_birth(@application.minor_date_of_birth["1"], @application.minor_date_of_birth["2"], @application.minor_date_of_birth["3"])
    end
    render "sponsor-a-child/check_answers"
  end

  def submit
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.partial_validation = [:full_validation]

    Rails.logger.debug "Submit JSON: #{@application.as_json}"

    if @application.valid?
      @application.save!(validate: false)
      session[:app_reference] = @application.reference
      session[:unaccompanied_minor] = {}

      SendUnaccompaniedMinorJob.perform_later(@application.id)
      GovNotifyMailer.send_unaccompanied_minor_confirmation_email(@application).deliver_later

      redirect_to "/sponsor-a-child/confirm"
    else
      Rails.logger.debug "****************************************************************"
      Rails.logger.debug "Errors: #{@application.errors}"
      Rails.logger.debug "errors.full_messages: #{@application.errors.full_messages}"
      Rails.logger.debug "****************************************************************"

      render "sponsor-a-child/check_answers"
    end
  end

  def confirm
    if session[:app_reference].nil?
      render "sponsor-a-child/guidance"
    else
      @app_reference = session[:app_reference]
      render "sponsor-a-child/confirm"
    end
  end

  def guidance
    # first page to show before the start page
    render "sponsor-a-child/guidance"
  end

  def task_list
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])

    if @application.is_cancelled?
      render "sponsor-a-child/cancel_confirm"
    elsif @application.is_submitted?
      render "sponsor-a-child/confirm"
    else
      render "sponsor-a-child/task_list"
    end
  end

  def non_eligible
    render "sponsor-a-child/non_eligible"
  end

  def save_or_cancel_application
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])

    if params[:cancel_application]
      # cancel an application
      if @application.is_cancelled?
        render "sponsor-a-child/cancel_confirm"
      else
        render "sponsor-a-child/cancel_application"
      end
    else
      # save and return later
      GovNotifyMailer.send_save_and_return_email(@application.given_name, "link", @application.email).deliver_later

      redirect_to "/sponsor-a-child/save-and-return/confirm"
    end
  end

  def  cancel_confirm
    if params[:cancel_application]
      # Soft delete the application
      @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
      @application.is_cancelled = true
      @application.save!(validate: false)

      session[:app_reference] = @application.reference

      # Remove application from session
      session[:unaccompanied_minor] = {}

      render "sponsor-a-child/cancel_confirm"
    else
      # Redirect to show the task-list
      redirect_to TASK_LIST_URI
    end
  end

  def remove_adult
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.adults_at_address = @application.adults_at_address.except!(params["key"]) if @application.adults_at_address.key?(params["key"])

    @application.update!(@application.as_json)

    if @application.adults_at_address.length.zero?
      @application.other_adults_address = "no"
      @application.adults_at_address = nil
      redirect_to "/sponsor-a-child/steps/#{ADULTS_AT_ADDRESS}"
    else
      redirect_to "/sponsor-a-child/steps/28"
    end
  end

  def remove_other_sponsor_name
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.other_names = @application.other_names.excluding([[params["given_name"], params["family_name"]]])

    if @application.other_names.length.zero?
      @application.has_other_names = "false"
      @application.other_names = nil
    end

    @application.update!(@application.as_json)

    if @application.other_names.blank?
      redirect_to TASK_LIST_URI
    else
      redirect_to "/sponsor-a-child/steps/13"
    end
  end

  def remove_other_nationality
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.other_nationalities = @application.other_nationalities.delete_if { |entry| entry[0].split.first == params["country_code"] }

    if @application.other_nationalities.length.zero?
      @application.has_other_nationalities = "false"
      @application.other_nationalities = nil
    end

    @application.update!(@application.as_json)

    if @application.other_nationalities.blank?
      redirect_to TASK_LIST_URI
    else
      redirect_to "/sponsor-a-child/steps/22"
    end
  end

private

  def path_for_step(to_step = nil)
    step = to_step || params["stage"].to_i
    "sponsor-a-child/steps/#{step}"
  end

  def render_current_step
    render path_for_step
  end

  def check_last_activity
    last_seen = Time.zone.parse(session[:last_seen])
    checkpoint = last_seen + last_seen_activity_threshold

    if checkpoint < Time.zone.now.utc
      redirect_to "/sponsor-a-child/session-expired"
    end
  end

  def save_and_redirect(filename, file)
    save_file(filename, file)

    @application.save!

    redirect_to TASK_LIST_URI
  end

  def save_file(filename, file)
    @service = StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    @service.write_file(filename, file)
  end

  def application_params
    params.require(:unaccompanied_minor)
        .permit(
          :reference,
          :is_under_18,
          :is_living_december,
          :is_born_after_december,
          :is_unaccompanied,
          :is_consent,
          :is_committed,
          :is_permitted,
          :have_parental_consent,
          :minor_date_of_birth,
          :minor_date_of_birth_as_string,
          :given_name,
          :family_name,
          :has_other_names,
          :other_given_name,
          :other_family_name,
          :other_names,
          :email,
          :email_confirm,
          :phone_number,
          :phone_number_confirm,
          :identification_type,
          :identification_number,
          :passport_identification_number,
          :id_identification_number,
          :refugee_identification_number,
          :no_identification_reason,
          :nationality,
          :has_other_nationalities,
          :other_nationality,
          :other_nationalities,
          :residential_line_1,
          :residential_line_2,
          :residential_town,
          :residential_postcode,
          :sponsor_address_line_1,
          :sponsor_address_line_2,
          :sponsor_address_town,
          :sponsor_address_postcode,
          :sponsor_date_of_birth,
          :agree_privacy_statement,
          :certificate_reference,
          :privacy_statement_confirm,
          :sponsor_declaration,
          :is_cancelled,
          :adult_number,
          :minor_given_name,
          :minor_family_name,
          :minor_email,
          :minor_email_confirm,
          :minor_phone_number,
          :minor_phone_number_confirm,
          :different_address,
          :other_adults_address,
          :adult_given_name,
          :adult_family_name,
          :adult_date_of_birth,
          :adult_nationality,
          :adult_identification_type,
          :adult_passport_identification_number,
          :adult_id_identification_number,
          :adult_refugee_identification_number,
          minor_contact_type: [],
        )
  end
end
