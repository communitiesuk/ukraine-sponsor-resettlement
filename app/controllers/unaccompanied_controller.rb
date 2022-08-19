require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper

  before_action :check_last_activity, only: %i[handle_step display]

  MAX_STEPS = 44
  NOT_ELIGIBLE = [-1, 0].freeze
  SPONSOR_OTHER_NAMES_CHOICE = 11
  SPONSOR_OTHER_NAMES = 12
  SPONSOR_ID_TYPE = 16
  SPONSOR_DATE_OF_BIRTH = 18
  SPONSOR_NATIONALITY = 19
  SPONSOR_OTHER_NATIONALITIES_CHOICE = 20
  SPONSOR_OTHER_NATIONALITY = 21
  ADULTS_AT_ADDRESS = 27
  ADULT_DATE_OF_BIRTH = 29
  ADULT_NATIONALITY = 30
  ADULT_ID_TYPE_AND_NUMBER = 31
  MINOR_DATE_OF_BIRTH = 34
  NATIONALITY_STEPS = [SPONSOR_NATIONALITY, SPONSOR_OTHER_NATIONALITY, ADULT_NATIONALITY].freeze
  ADULT_STEPS = [ADULT_DATE_OF_BIRTH, ADULT_NATIONALITY, ADULT_ID_TYPE_AND_NUMBER].freeze
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

    Rails.logger.debug "App JSON: #{@application.as_json}"

    step = params["stage"].to_i

    @feature_save_and_return_active = (ENV["UAM_FEATURE_SAVE_AND_RETURN_ACTIVE"] == "true")

    if step.positive? && step <= MAX_STEPS
      if NATIONALITY_STEPS.include?(step)
        @nationalities = get_nationalities_as_list
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
        Rails.logger.debug "Adult page!"

        # Set properties based on values from hash of adults
        @adult = @application.adults_at_address[params["key"]]

        Rails.logger.debug "Adult: #{@adult}"

        adult_dob = @adult["date_of_birth"]
        adult_nationality = @adult["nationality"]
        adult_id_type_and_number = @adult["id_type_and_number"]
        if adult_dob.present? && adult_dob.length.positive?
          @application.adult_date_of_birth = {
            3 => Date.parse(adult_dob).day,
            2 => Date.parse(adult_dob).month,
            1 => Date.parse(adult_dob).year,
          }
        end
        @application.nationality = adult_nationality if adult_nationality.present? && adult_nationality.length.positive?
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

      render "sponsor-a-child/steps/#{step}"
    else
      redirect_to "/sponsor-a-child"
    end
  end

  def handle_upload_uk
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
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

    if @application.valid?
      save_and_redirect(@application.uk_parental_consent_saved_filename, upload_params.tempfile)
    else
      render "sponsor-a-child/steps/#{params['stage']}"
    end
  end

  def handle_upload_ukraine
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
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

    if @application.valid?
      save_and_redirect(@application.ukraine_parental_consent_saved_filename, upload_params.tempfile)
    else
      render "sponsor-a-child/steps/#{params['stage']}"
    end
  end

  def handle_step
    current_step = params["stage"].to_i
    current_step.freeze

    # Pull session data out of session and
    # instantiate new or existing Application ActiveRecord object
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_step == 1

    if current_step == SPONSOR_OTHER_NAMES_CHOICE && (params["unaccompanied_minor"].blank? || params["unaccompanied_minor"]["has_other_names"].blank?)
      @application.errors.add(:has_other_names, I18n.t(:no_sponsor_other_name_choice_made, scope: :error))

      render_current_step
      return
    end

    # capture other names
    if current_step == SPONSOR_OTHER_NAMES
      param_other_given_name = params["unaccompanied_minor"]["other_given_name"]
      param_other_family_name = params["unaccompanied_minor"]["other_family_name"]

      if param_other_given_name.blank? || param_other_family_name.blank?
        if param_other_given_name.blank?
          @application.errors.add(:other_given_name, I18n.t(:invalid_given_name, scope: :error))
        else
          @previously_entered_other_given_name = param_other_given_name
        end

        if param_other_family_name.blank?
          @application.errors.add(:other_family_name, I18n.t(:invalid_family_name, scope: :error))
        else
          @previously_entered_other_family_name = param_other_family_name
        end

        render_current_step
        return
      end

      # adds other attributes
      (@application.other_names ||= []) << [param_other_given_name.strip, param_other_family_name.strip]
      # resets the current state
      params["unaccompanied_minor"]["other_given_name"] = ""
      params["unaccompanied_minor"]["other_family_name"] = ""
    end

    # capture identification document number
    if current_step == SPONSOR_ID_TYPE
      # Really don't like this! Validation logic should be in UAM_Validation class
      @application.identification_type = params["unaccompanied_minor"]["identification_type"]

      case @application.identification_type
      when "passport"
        @application.identification_number = params["unaccompanied_minor"]["passport_identification_number"]

        if @application.identification_number.strip.length.zero?
          @application.errors.add(:passport_identification_number, I18n.t(:invalid_id_number, scope: :error))

          render_current_step
          return
        end
      when "national_identity_card"
        @application.identification_number = params["unaccompanied_minor"]["id_identification_number"]

        if @application.identification_number.strip.length.zero?
          @application.errors.add(:id_identification_number, I18n.t(:invalid_id_number, scope: :error))

          render_current_step
          return
        end
      when "refugee_travel_document"
        @application.identification_number = params["unaccompanied_minor"]["refugee_identification_number"]

        if @application.identification_number.strip.length.zero?
          @application.errors.add(:refugee_identification_number, I18n.t(:invalid_id_number, scope: :error))

          render_current_step
          return
        end
      when "none"
        @application.identification_number = ""
      else
        @application.errors.add(:identification_type, I18n.t(:invalid_id_type, scope: :error))

        render_current_step
        return
      end
    end

    if current_step == SPONSOR_DATE_OF_BIRTH
      begin
        sponsor_dob = Date.new(params["unaccompanied_minor"]["sponsor_date_of_birth(1i)"].to_i, params["unaccompanied_minor"]["sponsor_date_of_birth(2i)"].to_i, params["unaccompanied_minor"]["sponsor_date_of_birth(3i)"].to_i)
        if 18.years.ago.to_date < sponsor_dob
          @application.errors.add(:sponsor_date_of_birth, I18n.t(:too_young_date_of_birth, scope: :error))

          render_current_step
          return
        end
      rescue Date::Error
        @application.errors.add(:sponsor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))

        render_current_step
        return
      end
    end

    if current_step == SPONSOR_NATIONALITY && params["unaccompanied_minor"]["nationality"].present? && !check_nationality_validity(params["unaccompanied_minor"]["nationality"])
      @application.errors.add(:nationality, I18n.t(:invalid_nationality, scope: :error))
      @nationalities = get_nationalities_as_list
      render_current_step
      return
    end

    if current_step == SPONSOR_OTHER_NATIONALITIES_CHOICE && (params["unaccompanied_minor"].blank? || params["unaccompanied_minor"]["has_other_nationalities"].blank?)
      @application.errors.add(:has_other_nationalities, I18n.t(:no_sponsor_other_nationalities_choice_made, scope: :error))

      render_current_step
      return
    end

    # capture other nationalities
    if current_step == SPONSOR_OTHER_NATIONALITY && params["unaccompanied_minor"]["other_nationality"].present?
      if !check_nationality_validity(params["unaccompanied_minor"]["other_nationality"])
        @application.errors.add(:other_nationality, I18n.t(:invalid_nationality, scope: :error))
        @nationalities = get_nationalities_as_list
        render_current_step
        return
      else
        # adds other attributes
        (@application.other_nationalities ||= []) << [params["unaccompanied_minor"]["other_nationality"]]
        # resets the current state
        params["unaccompanied_minor"]["other_nationality"] = ""
      end
    end

    if current_step == MINOR_DATE_OF_BIRTH
      # There must be a better way!
      begin
        minor_dob = Date.new(params["unaccompanied_minor"]["minor_date_of_birth(1i)"].to_i, params["unaccompanied_minor"]["minor_date_of_birth(2i)"].to_i, params["unaccompanied_minor"]["minor_date_of_birth(3i)"].to_i)

        if minor_dob < 18.years.ago.to_date
          @application.errors.add(:minor_date_of_birth, I18n.t(:too_old_date_of_birth, scope: :error))

          render_current_step
          return
        end
      rescue Date::Error
        @application.errors.add(:minor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))

        render_current_step
        return
      end
    end

    if current_step == ADULT_DATE_OF_BIRTH
      @adult = @application.adults_at_address[params["key"]]
      Rails.logger.debug "@adult: #{@adult}"
      begin
        adult_dob = Date.new(params["unaccompanied_minor"]["adult_date_of_birth(1i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(2i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(3i)"].to_i)

        if adult_dob > 16.years.ago.to_date
          @application.adults_at_address[params["key"]]["date_of_birth"] = ""
          @application.errors.add(:adult_date_of_birth, I18n.t(:not_over_16_years_old, scope: :error))

          render_current_step
          return
        else
          @application.adults_at_address[params["key"]]["date_of_birth"] = adult_dob
        end
      rescue Date::Error
        @application.adults_at_address[params["key"]]["date_of_birth"] = ""
        @application.errors.add(:adult_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))

        render_current_step
        return
      end
    end

    # capture the other adults at address
    # only store them if given and family name are not empty ("")
    if current_step == ADULTS_AT_ADDRESS && !(params["unaccompanied_minor"]["adult_given_name"].empty? && params["unaccompanied_minor"]["adult_family_name"].empty?)
      @application.adults_at_address = {} if @application.adults_at_address.nil?
      @application.adults_at_address.store(SecureRandom.uuid.upcase.to_s, Adult.new(params["unaccompanied_minor"]["adult_given_name"], params["unaccompanied_minor"]["adult_family_name"]))
    end

    # capture the over 16 year old at address nationality
    if current_step == ADULT_NATIONALITY && params["unaccompanied_minor"]["adult_nationality"].present?
      if !check_nationality_validity(params["unaccompanied_minor"]["adult_nationality"])
        @application.errors.add(:adult_nationality, I18n.t(:invalid_nationality, scope: :error))
        @nationalities = get_nationalities_as_list
        @adult = @application.adults_at_address[params["key"]]
        render_current_step
        return
      else
        @application.adults_at_address[params["key"]]["nationality"] = params["unaccompanied_minor"]["adult_nationality"]
      end
    end

    # capture the over 16 year old at address id type and number
    if current_step == ADULT_ID_TYPE_AND_NUMBER
      id_type = params["unaccompanied_minor"]["adult_identification_type"]
      @adult = @application.adults_at_address[params["key"]]

      if id_type.blank?
        @application.errors.add(:adult_identification_type, I18n.t(:invalid_id_type, scope: :error))
        render_current_step
        return
      elsif id_type == "passport"
        document_id = params["unaccompanied_minor"]["adult_passport_identification_number"]

        if document_id.blank?
          @application.errors.add(:adult_passport_identification_number, I18n.t(:invalid_id_number, scope: :error))
          render_current_step
          return
        end
      elsif id_type == "national_identity_card"
        document_id = params["unaccompanied_minor"]["national_identity_card"]

        if document_id.blank?
          @application.errors.add(:adult_id_identification_number, I18n.t(:invalid_id_number, scope: :error))
          render_current_step
          return
        end
      elsif id_type == "refugee_travel_document"
        document_id = params["unaccompanied_minor"]["refugee_travel_document"]

        if document_id.blank?
          @application.errors.add(:adult_refugee_identification_number, I18n.t(:invalid_id_number, scope: :error))
          render_current_step
          return
        end
      end

      @adult["id_type_and_number"] = case params["unaccompanied_minor"]["adult_identification_type"]
                                     when "passport"
                                       "#{params['unaccompanied_minor']['adult_identification_type']} - #{params['unaccompanied_minor']['adult_passport_identification_number']}"
                                     when "national_identity_card"
                                       "#{params['unaccompanied_minor']['adult_identification_type']} - #{params['unaccompanied_minor']['adult_id_identification_number']}"
                                     when "refugee_travel_document"
                                       "#{params['unaccompanied_minor']['adult_identification_type']} - #{params['unaccompanied_minor']['adult_refugee_identification_number']}"
                                     else
                                       "#{params['unaccompanied_minor']['adult_identification_type']} - 123456789"
                                     end
    end

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the database
      @application.update!(@application.as_json)

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
    else
      render "sponsor-a-child/steps/#{params['stage']}"
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
    @application.final_submission = true

    Rails.logger.debug "Submit JSON: #{@application.as_json}"
    isvalid = @application.valid?

    unless isvalid
      if @application.errors.include?(:adult_given_name)
        @application.errors.delete(:adult_given_name)
      end
      if @application.errors.include?(:adult_family_name)
        @application.errors.delete(:adult_family_name)
      end
      if @application.errors.include?(:adult_date_of_birth)
        @application.errors.delete(:adult_date_of_birth)
      end

      isvalid = @application.errors.empty?
    end

    if isvalid
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
    @app_reference = session[:app_reference]

    render "sponsor-a-child/confirm"
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

  def render_current_step
    current_step = params["stage"].to_i
    current_step.freeze

    render "sponsor-a-child/steps/#{current_step}"
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

  def check_nationality_validity(nationality)
    nationality_name = nationality.split(" - ")[1]
    nationality_struct = OpenStruct.new(val: nationality, name: nationality_name)
    if !get_nationalities_as_list.include?(nationality_struct) || nationality == "---"
      false
    else
      true
    end
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
          :phone_number,
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
          :minor_contact_type,
          :minor_email,
          :minor_phone_number,
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
        )
  end
end
