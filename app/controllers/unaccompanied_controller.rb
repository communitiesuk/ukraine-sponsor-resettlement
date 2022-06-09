class UnaccompaniedController < ApplicationController
  MAX_STEPS = 2

  def display
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      render "unaccompanied-minor/steps/#{step}"
    else
      redirect_to "/unaccompanied-minor"
    end
  end

  def handle_upload
    # TODO: handle no file selected
    upload_params = params.require("unaccompanied_minor")["parental_consent"]
    # TODO: actually upload file
    # file = upload_params.tempfile

    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])
    @application.started_at = Time.zone.now.utc if params["stage"].to_i == 1

    @application.parental_consent_file_type = upload_params.content_type
    @application.parental_consent_filename = upload_params.original_filename

    if @application.valid?
      session[:unaccompanied_minor] = @application.as_json

      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(params["stage"].to_i)

      redirect_to "/unaccompanied-minor/steps/#{next_stage}"
    else
      render "unaccompanied-minor/steps/#{params["stage"]}"
    end
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
      next_stage = RoutingEngine.get_next_unaccompanied_minor_step(params["stage"].to_i)

      if next_stage > MAX_STEPS
        redirect_to "/unaccompanied-minor/check-answers"
      else
        redirect_to "/unaccompanied-minor/steps/#{next_stage}"
      end
    else
      render "unaccompanied-minor/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minor])

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

      # SendIndividualUpdateJob.perform_later(@application.id)
      # GovNotifyMailer.send_individual_confirmation_email(@application).deliver_later
      redirect_to "/unaccompanied-minor/confirm"
    else
      Rails.logger.debug "Invalid!"

      render "unaccompanied-minor/check_answers"
    end
  end

  def confirm
    @app_reference = session[:app_reference]

    render "unaccompanied-minor/confirm"
  end

private

  def application_params
    params.require(:unaccompanied_minor)
        .permit(
          :reference,
          :parental_consent,
          :fullname,
        )
  end
end
