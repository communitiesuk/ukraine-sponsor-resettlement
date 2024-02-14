require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper
  include CommonValidations

  before_action :check_last_activity, only: %i[handle_step display]

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
    step = params["stage"].to_s

    if @application.nil? || !UamWorkflow.states.key?(step)
      redirect_to "/sponsor-a-child" and return
    end

    if (UamWorkflow.state_has_tag(step, :adult_step) || UamWorkflow.state_has_tag(step, :adult_summary)) && \
        @application.other_adults_address.present? && \
        (params["key"].blank? || @application.adults_at_address.blank?)
      render "sponsor-a-child/task_list"
      return
    end

    if UamWorkflow.state_has_tag(step, :nationality_step)
      @nationalities = if UamWorkflow.state_has_tag(step, :other_nationality)
                         get_nationalities_as_list(@application.saved_nationalities_as_list)
                       else
                         get_nationalities_as_list
                       end
    end

    if UamWorkflow.state_has_tag(step, :save_and_return_1) || UamWorkflow.state_has_tag(step, :save_and_return_2)
      if request.GET["save"]
        @save_and_return_message = true
        @save = "?save=1"
      else
        @save = ""
      end
    end

    if UamWorkflow.state_has_tag(step, :sponsor_id_type)
      case @application.identification_type
      when "passport"
        @application.passport_identification_number = @application.identification_number
      when "national_identity_card"
        @application.id_identification_number = @application.identification_number
      when "biometric_residence"
        @application.biometric_residence_identification_number = @application.identification_number
      when "photo_driving_licence"
        @application.photo_driving_licence_identification_number = @application.identification_number
      end
    elsif UamWorkflow.state_has_tag(step, :adult_step)
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
          when "biometric_residence"
            @application.adult_biometric_residence_identification_number = id_type_and_number[1].to_s
          when "photo_driving_license"
            @application.adult_photo_driving_licence_identification_number = id_type_and_number[1].to_s
          end
        end
      end
    end

    render_current_step
  end

  def handle_upload_uk
    current_stage = params["stage"].to_s
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_stage == UamWorkflow.states.keys[0]
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
    current_stage = params["stage"].to_s
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_stage == UamWorkflow.states.keys[0]
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
    current_step = params["stage"].to_s
    # Pull session data out of session and
    # instantiate new or existing Application ActiveRecord object
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.started_at = Time.zone.now.utc if current_step == UamWorkflow.states.keys[0]

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    @application.partial_validation = if !application_params.keys.empty? && application_params.keys[0].start_with?("sponsor_date_of_birth")
                                        [:sponsor_date_of_birth]
                                      elsif !application_params.keys.empty? && application_params.keys[0].start_with?("minor_date_of_birth")
                                        [:minor_date_of_birth]
                                      elsif !application_params.keys.empty? && application_params.keys[0].start_with?("adult_date_of_birth")
                                        [:adult_date_of_birth]
                                      elsif application_params.key?("identification_type") || application_params.key?("id_identification_number")
                                        %i[identification_type passport_identification_number id_identification_number biometric_residence_identification_number photo_driving_licence_identification_number]
                                      else
                                        application_params.keys.map(&:to_sym)
                                      end

    if @application.valid?
      session[:has_error] = ""
      UamWorkflow.do_data_transforms(current_step, @application, params)
      @application.update!(@application.as_json)

      # Special steps if we are in save_and_return territory
      if request.GET["save"]
        if UamWorkflow.state_has_tag(current_step, :save_and_return_1)
          next_step = UamWorkflow.find_by_tag(:save_and_return_2)
          redirect_to "/sponsor-a-child/steps/#{next_step}?save=1"
        elsif UamWorkflow.state_has_tag(current_step, :save_and_return_2)
          redirect_to "/sponsor-a-child/save-and-return/"
        end
      else
        next_stage = UamWorkflow.get_next_step(current_step, @application)
        if next_stage == "non-eligible"
          redirect_to "/sponsor-a-child/non-eligible"
        elsif next_stage == "task-list"
          redirect_to TASK_LIST_URI
        elsif UamWorkflow.state_has_tag(next_stage, :adult_step)
          redirect_to "/sponsor-a-child/steps/#{next_stage}/#{params['key']}"
        else
          redirect_to "/sponsor-a-child/steps/#{next_stage}"
        end
      end
    else
      # Validation failed. Expose the data needed on the steps that need it.
      session[:has_error] = "Error - "
      if UamWorkflow.state_has_tag(current_step, :nationality_step)
        @nationalities = get_nationalities_as_list(@application.saved_nationalities_as_list)
      end

      if UamWorkflow.state_has_tag(current_step, :adult_step)
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

    if @application.adults_at_address.empty?
      @application.other_adults_address = "no"
      @application.adults_at_address = nil
      adults_at_address_step = UamWorkflow.find_by_tag(:adults_at_address)
      redirect_to "/sponsor-a-child/steps/#{adults_at_address_step}"
    else
      adult_summary = UamWorkflow.find_by_tag(:adult_summary)
      redirect_to "/sponsor-a-child/steps/#{adult_summary}"
    end
  end

  def remove_other_sponsor_name
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.other_names = @application.other_names.excluding([[params["given_name"], params["family_name"]]])

    if @application.other_names.empty?
      @application.has_other_names = "false"
      @application.other_names = nil
    end

    @application.update!(@application.as_json)

    if @application.other_names.blank?
      redirect_to TASK_LIST_URI
    else
      uns = UamWorkflow.find_by_tag(:other_names_summary)
      redirect_to "/sponsor-a-child/steps/#{uns}"
    end
  end

  def remove_other_nationality
    @application = UnaccompaniedMinor.find_by_reference(session[:app_reference])
    @application.other_nationalities = @application.other_nationalities.delete_if { |entry| entry[0].split.first == params["country_code"] }

    if @application.other_nationalities.empty?
      @application.has_other_nationalities = "false"
      @application.other_nationalities = nil
    end

    @application.update!(@application.as_json)

    if @application.other_nationalities.blank?
      redirect_to TASK_LIST_URI
    else
      ns = UamWorkflow.find_by_tag(:nationalities_summary)
      redirect_to "/sponsor-a-child/steps/#{ns}"
    end
  end

private

  def render_current_step
    step = params["stage"].to_s
    if UamWorkflow.states.key?(step)
      render UamWorkflow.states[step][:view_name]
    else
      redirect_to "/404"
    end
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
          :biometric_residence_identification_number,
          :photo_driving_licence_identification_number,
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
          :adult_biometric_residence_identification_number,
          :adult_photo_driving_licence_identification_number,
          minor_contact_type: [],
        )
  end
end
