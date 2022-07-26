require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper
  MAX_STEPS = 44
  NOT_ELIGIBLE = [-1, 0].freeze
  MINOR_OTHER_NAMES = 12
  MINOR_ID_TYPE = 16
  SPONSOR_DATE_OF_BIRTH = 18
  MINOR_NATIONALITY = 19
  MINOR_OTHER_NATIONALITY = 21
  ADULTS_AT_ADDRESS = 27
  ADULT_DATE_OF_BIRTH = 29
  ADULT_NATIONALITY = 30
  ADULT_ID_TYPE_AND_NUMBER = 31
  MINOR_DATE_OF_BIRTH = 34
  NATIONALITY_STEPS = [MINOR_NATIONALITY, MINOR_OTHER_NATIONALITY, ADULT_NATIONALITY].freeze
  ADULT_STEPS = [ADULT_DATE_OF_BIRTH, ADULT_NATIONALITY, ADULT_ID_TYPE_AND_NUMBER].freeze
  TASK_LIST_STEP = 999

  def start
    render "sponsor-a-child/start"
  end

  def check_if_can_use
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if @application.started_at.nil?
    @application.save! if @application.reference.nil?

    # Update the session
    session[:unaccompanied_minor] = @application.as_json
    session[:app_reference] = @application.reference

    # mini-check page to show after start and before step 1
    render "sponsor-a-child/check_if_can_use"
  end

  def start_application
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if @application.started_at.nil?
    @application.save! if @application.reference.nil?

    # Update the session
    session[:unaccompanied_minor] = @application.as_json
    session[:app_reference] = @application.reference

    # Redirect to show the task-list
    redirect_to "/sponsor-a-child/task-list"
  end

  def display
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])

    # Update the session
    session[:unaccompanied_minor] = @application.as_json

    Rails.logger.debug "App JSON: #{@application.as_json}"

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      if NATIONALITY_STEPS.include?(step)
        @nationalities = get_nationalities_as_list
      elsif ADULT_STEPS.include?(step)
        # Set properties based on values from hash of adults
        @adult = @application.adults_at_address[params["key"]]
        adult_dob = @adult["date_of_birth"]
        adult_nationality = @adult["nationality"]
        adult_id_type_and_number = @adult["id_type_and_number"]
        if adult_dob.present? && adult_dob.length.positive?
          @application.adult_date_of_birth_day = Date.parse(adult_dob).day
          @application.adult_date_of_birth_month = Date.parse(adult_dob).month
          @application.adult_date_of_birth_year = Date.parse(adult_dob).year
        end
        @application.nationality = adult_nationality if adult_nationality.present? && adult_nationality.length.positive?
        @application.adult_identification_type = adult_id_type_and_number if adult_id_type_and_number.present? && adult_id_type_and_number.length.positive?
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
    # Pull session data out of session and
    # instantiate new or existing Application ActiveRecord object
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1

    # capture other names
    if params["stage"].to_i == MINOR_OTHER_NAMES
      # adds other attributes
      (@application.other_names ||= []) << [params["unaccompanied_minor"]["other_given_name"], params["unaccompanied_minor"]["other_family_name"]]
      # resets the current state
      params["unaccompanied_minor"]["other_given_name"] = ""
      params["unaccompanied_minor"]["other_family_name"] = ""
    end

    # capture identification document number
    if params["stage"].to_i == MINOR_ID_TYPE
      # how to have this comparison dealt with better???
      if params["unaccompanied_minor"]["identification_type"][0].casecmp("none").zero?
        @application.identification_type = ""
        @application.identification_number = ""
      elsif params["unaccompanied_minor"]["identification_number"].present?
        @application.identification_number = params["unaccompanied_minor"]["identification_number"]
      end
    end

    if params["stage"].to_i == SPONSOR_DATE_OF_BIRTH
      # There must be a better way!
      begin
        minor_dob = Date.new(params["unaccompanied_minor"]["sponsor_date_of_birth_year"].to_i, params["unaccompanied_minor"]["sponsor_date_of_birth_month"].to_i, params["unaccompanied_minor"]["sponsor_date_of_birth_day"].to_i)

        if minor_dob > 18.years.ago.to_date
          @application.errors.add(:sponsor_date_of_birth_day, I18n.t(:too_young_date_of_birth, scope: :error))

          render "sponsor-a-child/steps/#{SPONSOR_DATE_OF_BIRTH}"
          return
        end
      rescue Date::Error
        @application.errors.add(:sponsor_date_of_birth_day, I18n.t(:invalid_date_of_birth, scope: :error))

        render "sponsor-a-child/steps/#{SPONSOR_DATE_OF_BIRTH}"
        return
      end
    end

    # capture other nationalities
    if params["stage"].to_i == MINOR_OTHER_NATIONALITY
      # adds other attributes
      (@application.other_nationalities ||= []) << [params["unaccompanied_minor"]["other_nationality"]]
      # resets the current state
      params["unaccompanied_minor"]["other_nationality"] = ""
    end

    if params["stage"].to_i == MINOR_DATE_OF_BIRTH
      # There must be a better way!
      begin
        minor_dob = Date.new(params["unaccompanied_minor"]["minor_date_of_birth_year"].to_i, params["unaccompanied_minor"]["minor_date_of_birth_month"].to_i, params["unaccompanied_minor"]["minor_date_of_birth_day"].to_i)

        if minor_dob < 18.years.ago.to_date
          @application.errors.add(:minor_date_of_birth_day, I18n.t(:too_old_date_of_birth, scope: :error))

          render "sponsor-a-child/steps/#{MINOR_DATE_OF_BIRTH}"
          return
        end
      rescue Date::Error
        @application.errors.add(:minor_date_of_birth_day, I18n.t(:invalid_date_of_birth, scope: :error))

        render "sponsor-a-child/steps/#{MINOR_DATE_OF_BIRTH}"
        return
      end
    end

    if params["stage"].to_i == ADULT_DATE_OF_BIRTH
      # There must be a better way!
      @adult = @application.adults_at_address[params["key"]]
      begin
        adult_dob = Date.new(params["unaccompanied_minor"]["adult_date_of_birth_year"].to_i, params["unaccompanied_minor"]["adult_date_of_birth_month"].to_i, params["unaccompanied_minor"]["adult_date_of_birth_day"].to_i)

        if adult_dob > 16.years.ago.to_date
          @application.adults_at_address[params["key"]]["date_of_birth"] = ""
          @application.errors.add(:adult_date_of_birth_day, I18n.t(:not_over_16_years_old, scope: :error))

          render "sponsor-a-child/steps/#{ADULT_DATE_OF_BIRTH}"
          return
        else
          @application.adults_at_address[params["key"]]["date_of_birth"] = adult_dob
        end
      rescue Date::Error
        @application.adults_at_address[params["key"]]["date_of_birth"] = ""
        @application.errors.add(:adult_date_of_birth_day, I18n.t(:invalid_date_of_birth, scope: :error))

        render "sponsor-a-child/steps/#{MINOR_DATE_OF_BIRTH}"
        return
      end
    end

    # capture the other adults at address
    if params["stage"].to_i == ADULTS_AT_ADDRESS
      @application.adults_at_address = {} if @application.adults_at_address.nil?
      @application.adults_at_address.store(SecureRandom.uuid.upcase.to_s, Adult.new(params["unaccompanied_minor"]["adult_given_name"], params["unaccompanied_minor"]["adult_family_name"]))
    end

    # capture the over 16 year old at address nationality
    if params["stage"].to_i == ADULT_NATIONALITY
      @application.adults_at_address[params["key"]]["nationality"] = params["unaccompanied_minor"]["adult_nationality"]
    end

    # capture the over 16 year old at address id type and number
    if params["stage"].to_i == ADULT_ID_TYPE_AND_NUMBER
      if params["unaccompanied_minor"]["adult_identification_type"] == "passport"
        @application.adults_at_address[params["key"]]["id_type_and_number"] = "#{params["unaccompanied_minor"]["adult_identification_type"]} - #{params["unaccompanied_minor"]["adult_passport_identification_number"]}"
      elsif params["unaccompanied_minor"]["adult_identification_type"] == "national_identity_card"
        @application.adults_at_address[params["key"]]["id_type_and_number"] = "#{params["unaccompanied_minor"]["adult_identification_type"]} - #{params["unaccompanied_minor"]["adult_id_identification_number"]}"
      elsif params["unaccompanied_minor"]["adult_identification_type"] == "refugee_travel_document"
        @application.adults_at_address[params["key"]]["id_type_and_number"] = "#{params["unaccompanied_minor"]["adult_identification_type"]} - #{params["unaccompanied_minor"]["adult_refugee_identification_number"]}"
      else
        @application.adults_at_address[params["key"]]["id_type_and_number"] = params["unaccompanied_minor"]["adult_identification_type"]
      end

    end

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the database
      @application.update!(@application.as_json)

      # Update the session
      session[:unaccompanied_minor] = @application.as_json

      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(@application, params["stage"].to_i)

      if NOT_ELIGIBLE.include?(next_stage)
        redirect_to "/sponsor-a-child/non-eligible"
      elsif next_stage == TASK_LIST_STEP
        # Redirect to show the task-list
        redirect_to "/sponsor-a-child/task-list"
      elsif next_stage > MAX_STEPS
        redirect_to "/sponsor-a-child/check-answers"
      elsif ADULT_STEPS.include?(next_stage)
        redirect_to "/sponsor-a-child/steps/#{next_stage}/#{params["key"]}"
      else
        redirect_to "/sponsor-a-child/steps/#{next_stage}"
      end
    else
      render "sponsor-a-child/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    # commented as question not asked yet so always nil

    @application.minor_date_of_birth_as_string = format_date_of_birth @application.minor_date_of_birth
    @application.sponsor_date_of_birth_as_string = format_date_of_birth @application.sponsor_date_of_birth

    render "sponsor-a-child/check_answers"
  end

  def submit
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.final_submission = true

    if @application.valid?
      @application.save!
      session[:app_reference] = @application.reference
      session[:unaccompanied_minor] = {}

      SendUnaccompaniedMinorJob.perform_later(@application.id)
      GovNotifyMailer.send_unaccompanied_minor_confirmation_email(@application).deliver_later

      redirect_to "/sponsor-a-child/confirm"
    else
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

    # Ensure session matches application
    session[:unaccompanied_minor] = @application.as_json

    if @application.is_cancelled?
      render "sponsor-a-child/cancel_confirm"
    elsif @application.is_submitted?
      render "sponsor-a-child/confirm"
    else
      render "sponsor-a-child/task_list"
    end
  end

  def non_eligible
    # page to show if between steps 1 and 8 (2,6 excluded) the user answers with
    # NO to any of the questions asked
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

      redirect_to "/sponsor-a-child/save-and-return-confirm"
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
      redirect_to "/sponsor-a-child/task-list"
    end
  end

  def save_return_confirm
    render "sponsor-a-child/save_return_confirm"
  end

  def save_return
    # lnk = params[:lnk]

    redirect_to "/sponsor-a-child/save-and-return-expired"
  end

  def save_return_expired
    @application = UnaccompaniedMinor.new

    render "sponsor-a-child/save_return_expired"
  end

  def resend_link
    email_address = params["unaccompanied_minor"]["email"]

    if email_address.present?
      @application = UnaccompaniedMinor.find_by_email(email_address)

      if @application.nil?
        # No application found
        @application = UnaccompaniedMinor.new
        @application.errors.add(:email, I18n.t(:no_application_found, scope: :error))

        render "sponsor-a-child/save_return_expired"
      end

    else
      @application = UnaccompaniedMinor.new
      @application.errors.add(:email, I18n.t(:invalid_email, scope: :error))

      render "sponsor-a-child/save_return_expired"
    end
  end

  def remove_adult
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.adults_at_address = @application.adults_at_address.except!(params["key"]) if @application.adults_at_address.key?(params["key"])

    @application.update!(@application.as_json)

    if @application.adults_at_address.length.zero?
      redirect_to "/sponsor-a-child/steps/#{ADULTS_AT_ADDRESS}"
    else
      redirect_to "/sponsor-a-child/steps/28"
    end
  end

private

  def save_and_redirect(filename, file)
    save_file(filename, file)

    redirect_to "/sponsor-a-child/task-list"
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
          :minor_date_of_birth_day,
          :minor_date_of_birth_month,
          :minor_date_of_birth_year,
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
          :adult_date_of_birth_day,
          :adult_date_of_birth_month,
          :adult_date_of_birth_year,
          :adult_nationality,
          :adult_identification_type,
          :adult_passport_identification_number,
          :adult_id_identification_number,
          :adult_refugee_identification_number,
        )
  end
end
