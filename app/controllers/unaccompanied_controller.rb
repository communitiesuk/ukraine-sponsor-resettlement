require "securerandom"

class UnaccompaniedController < ApplicationController
  include ApplicationHelper
  MAX_STEPS = 12

  def start
    render "unaccompanied-minor/start"
  end

  def display
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      render "unaccompanied-minor/steps/#{step}"
    else
      redirect_to "/unaccompanied-minor"
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
    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the session
      session[:unaccompanied_minor] = @application.as_json

      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(@application, params["stage"].to_i)

      if next_stage == -1
        redirect_to "/unaccompanied-minor/non-eligible"
      elsif next_stage > MAX_STEPS
        redirect_to "/unaccompanied-minor/check-answers"
      else
        redirect_to "/unaccompanied-minor/steps/#{next_stage}"
      end
    else
      Rails.logger.debug "Invalid!"

      render "unaccompanied-minor/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.minor_date_of_birth_as_string = format_date_of_birth @application.minor_date_of_birth
    @application.sponsor_date_of_birth_as_string = format_date_of_birth @application.sponsor_date_of_birth

    render "unaccompanied-minor/check_answers"
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

      redirect_to "/unaccompanied-minor/confirm"
    else
      render "unaccompanied-minor/check_answers"
    end
  end

  def confirm
    @app_reference = session[:app_reference]

    render "unaccompanied-minor/confirm"
  end

  def guidance
    # first page to show before the start page
    render "unaccompanied-minor/guidance"
  end

  def check_if_can_use
    # mini-check page to show after start and before step 1
    render "unaccompanied-minor/check_if_can_use"
  end

  def task_list
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])

    render "unaccompanied-minor/task_list"
  end

  def non_eligible
    # page to show if between steps 1 and 8 (2,6 excluded) the user answers with
    # NO to any of the questions asked
    render "unaccompanied-minor/non_eligible"
  end

  def cancel_application
    # cancel an application
    @application = UnaccompaniedMinor.find_by_reference(params[:reference])

    if @application.is_cancelled?
      render "unaccompanied-minor/cancel_confirm"
    else
      render "unaccompanied-minor/cancel_application"
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

      render "unaccompanied-minor/cancel_confirm"
    else
      # Redirect to show the task-list
      redirect_to "/unaccompanied-minor/task-list"
    end
  end

private

  def save_and_redirect(application, filename, file)
    if application.valid?
      save_file(filename, file)

      session[:unaccompanied_minor] = application.as_json

      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(application, params["stage"].to_i)

      redirect_to "/unaccompanied-minor/steps/#{next_stage}"
    else
      render "unaccompanied-minor/steps/#{params['stage']}"
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
          :minor_fullname,
          :minor_date_of_birth,
          :minor_date_of_birth_as_string,
          :fullname,
          :email,
          :phone_number,
          :residential_line_1,
          :residential_line_2,
          :residential_town,
          :residential_postcode,
          :sponsor_date_of_birth,
          :agree_privacy_statement,
          :certificate_reference,
          :is_cancelled
        )
  end
end
