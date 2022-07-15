require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper
<<<<<<< HEAD
  MAX_STEPS = 44
=======
  MAX_STEPS = 24
>>>>>>> df59a15 (Add child contact details)

  def start
    render "sponsor-a-child/start"
  end

  def start_application
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if @application.started_at.nil?
    @application.save! if @application.reference.nil?

    # Redirect to show the task-list
    redirect_to "/sponsor-a-child/task-list/#{@application.reference}"
  end

  def display
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      if [19, 21].include?(step)
        @nationalities = get_nationalities_as_list
      end
      render "sponsor-a-child/steps/#{step}"
    else
      redirect_to "/sponsor-a-child"
    end
  end

  def handle_upload_uk
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
    @application.uk_parental_consent_filename = ""

    begin
      upload_params = params.require("unaccompanied_minor")["uk_parental_consent"]

      @application.uk_parental_consent_file_type = upload_params.content_type
      @application.uk_parental_consent_filename = upload_params.original_filename
      @application.uk_parental_consent_saved_filename = "#{SecureRandom.uuid.upcase}-#{upload_params.original_filename}"
      Rails.logger.debug "New filename: #{@application.uk_parental_consent_saved_filename}"
    rescue ActionController::ParameterMissing
      # Do nothing!
      Rails.logger.debug "No upload file found!"
    end

    save_and_redirect(@application, @application.uk_parental_consent_saved_filename, upload_params.tempfile)
  end

  def handle_upload_ukraine
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1
    @application.ukraine_parental_consent_filename = ""

    begin
      upload_params = params.require("unaccompanied_minor")["ukraine_parental_consent"]

      @application.ukraine_parental_consent_file_type = upload_params.content_type
      @application.ukraine_parental_consent_filename = upload_params.original_filename
      @application.ukraine_parental_consent_saved_filename = "#{SecureRandom.uuid.upcase}-#{upload_params.original_filename}"
      Rails.logger.debug "New filename: #{@application.ukraine_parental_consent_saved_filename}"
    rescue ActionController::ParameterMissing
      # Do nothing!
      Rails.logger.debug "No upload file found!"
    end

    save_and_redirect(@application, @application.ukraine_parental_consent_saved_filename, upload_params.tempfile)
  end

  def handle_step
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1

    # capture other names
    if params["stage"].to_i == 12
      # adds other attributes
      (@application.other_names ||= []) << [params["unaccompanied_minor"]["other_given_name"], params["unaccompanied_minor"]["other_family_name"]]
      # resets the current state
      params["unaccompanied_minor"]["other_given_name"] = ""
      params["unaccompanied_minor"]["other_family_name"] = ""
    end

    # capture identification document number
    if params["stage"].to_i == 16
      # how to have this comparison dealt with better???
      if params["unaccompanied_minor"]["identification_type"][0].casecmp("none").zero?
        @application.identification_type = ""
        @application.identification_number = ""
      elsif params["unaccompanied_minor"]["identification_number"].present?
        @application.identification_number = params["unaccompanied_minor"]["identification_number"]
      end
    end

    # capture other nationalities
    if params["stage"].to_i == 21
      # adds other attributes
      (@application.other_nationalities ||= []) << [params["unaccompanied_minor"]["other_nationality"]]
      # resets the current state
      params["unaccompanied_minor"]["other_nationality"] = ""
    end

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the session
      session[:unaccompanied_minor] = @application.as_json

      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(@application, params["stage"].to_i)

      if next_stage == -1
        redirect_to "/sponsor-a-child/non-eligible"
      elsif next_stage.zero?
        redirect_to "/sponsor-a-child/non-eligible"
      elsif next_stage > MAX_STEPS
        redirect_to "/sponsor-a-child/check-answers"
      else
        redirect_to "/sponsor-a-child/steps/#{next_stage}"
      end
    else
      Rails.logger.debug "Invalid!"

      render "sponsor-a-child/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    # commented as question not asked yet so always nil

    # @application.minor_date_of_birth_as_string = format_date_of_birth @application.minor_date_of_birth
    # @application.sponsor_date_of_birth_as_string = format_date_of_birth @application.sponsor_date_of_birth

    render "sponsor-a-child/check_answers"
  end

  def submit
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
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

  def check_if_can_use
    # mini-check page to show after start and before step 1
    render "sponsor-a-child/check_if_can_use"
  end

  def task_list
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application = UnaccompaniedMinor.find_by_reference(params[:reference]) if @application.reference != params[:reference]

    # Ensure session matches application
    session[:unaccompanied_minor] = @application.as_json

    if @application.is_cancelled?
      render "sponsor-a-child/cancel_confirm"
    else
      render "sponsor-a-child/task_list"
    end
  end

  def non_eligible
    # page to show if between steps 1 and 8 (2,6 excluded) the user answers with
    # NO to any of the questions asked
    render "sponsor-a-child/non_eligible"
  end

  def check_box_check
    @application = UnaccompaniedMinor.find_by_reference(params[:reference])
    if @application.valid?
      # if they confirm they will be redirected to next page
      redirect_to "/ste"
    else
      # if they do not confirm reload page and show error
      render "/send-application/data_sharing"
    end
  end

  def cancel_application
    # cancel an application
    @application = UnaccompaniedMinor.find_by_reference(params[:reference])

    if @application.is_cancelled?
      render "sponsor-a-child/cancel_confirm"
    else
      render "sponsor-a-child/cancel_application"
    end
  end

  def  cancel_confirm
    if params[:cancel_application]
      # Soft delete the application
      @application = UnaccompaniedMinor.find_by_reference(params[:reference])
      @application.update!(is_cancelled: true)

      session[:app_reference] = @application.reference

      # Remove application from session
      session[:unaccompanied_minor] = {}

      render "sponsor-a-child/cancel_confirm"
    else
      # Redirect to show the task-list
      redirect_to "/sponsor-a-child/task-list/#{params[:reference]}"
    end
  end

private

  def save_and_redirect(application, filename, file)
    if application.valid?
      save_file(filename, file)

      session[:unaccompanied_minor] = application.as_json

      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(application, params["stage"].to_i)

      redirect_to "/sponsor-a-child/steps/#{next_stage}"
    else
      render "sponsor-a-child/steps/#{params['stage']}"
    end
  end

  def save_file(filename, file)
    @service = StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    @service.write_file(filename, file)
  end

  def application_params
    params.require(:unaccompanied_minor)
        .permit(
          :reference,
          :is_eligible,
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
          :no_identification_reason,
          :nationality,
          :has_other_nationalities,
          :other_nationality,
          :other_nationalities,
          :residential_line_1,
          :residential_line_2,
          :residential_town,
          :residential_postcode,
          :sponsor_date_of_birth,
          :agree_privacy_statement,
          :certificate_reference,
          :privacy_statement_confirm,
          :sponsor_declaration,
          :is_cancelled,
<<<<<<< HEAD
          :adult_number,
          :minor_contact_details,
=======
          :minor_given_name,
          :minor_family_name,
          :minor_contact_type,
          :minor_email,
          :minor_phone_number,
>>>>>>> df59a15 (Add child contact details)
        )
  end
end
