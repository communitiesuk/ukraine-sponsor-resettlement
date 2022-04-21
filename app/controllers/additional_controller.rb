class AdditionalController < ApplicationController
  MAX_STEPS = 99

  def home
    @application = AdditionalInfo.new(session[:additional_info])

    reference = params["reference"]

    if reference.present? && reference.upcase.match(/ANON-\w{4}-\w{4}-\w{1}/)
      render "additional-info/start"
    else
      redirect_to "/additional-info"
    end
  end

  def start
    @application = AdditionalInfo.new(session[:additional_info])
    @application.started_at = Time.zone.now.utc
    @application.reference = params["reference"].upcase

    # Update the session
    session[:additional_info] = @application.as_json

    redirect_to "/additional-info/steps/1"
  end

  def display
    @application = AdditionalInfo.new(session[:additional_info])

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      render "/additional-info/steps/#{step}"
    else
      redirect_to "/additional-info"
    end
  end

  def handle_step
    # Pull session data out of session and
    # instantiate new Application ActiveRecord object
    @application = AdditionalInfo.new(session[:additional_info])

    # Update Application object with new attributes
    @application.assign_attributes(application_params)

    if @application.valid?
      # Update the session
      session[:additional_info] = @application.as_json

      # Replace with routing engine to get next stage
      next_stage = RoutingEngine.get_next_step(@application, params["stage"].to_i)

      if next_stage == 999
        redirect_to "/additional-info/check-answers"
      else
        redirect_to "/additional-info/steps/#{next_stage}"
      end
    else
      render "additional-info/steps/#{params['stage']}"
    end
  end

  def check_answers
    @application = AdditionalInfo.new(session[:additional_info])

    render "additional-info/check_answers"
  end

  def submit
    @application = AdditionalInfo.new(session[:additional_info])
    @application.ip_address = request.ip
    @application.user_agent = request.user_agent
    @application.final_submission = true

    # Set default answers for skipped questions
    if @application.residential_pet.blank?
      @application.residential_pet = "no"
    end

    @application.save!

    session[:app_reference] = @application.reference
    session[:additional_info] = {}

    SendAdditionalInfoUpdateJob.perform_later(@application.id)
    GovNotifyMailer.send_additional_info_confirmation_email(@application).deliver_later

    redirect_to "/additional-info/confirm"
  end

  def confirm
    @app_reference = session[:app_reference]

    render "additional-info/confirm"
  end

  private

  def application_params
    params.require(:additional_info)
        .permit(
          :reference,
          :residential_line_1,
          :residential_line_2,
          :residential_town,
          :residential_postcode,
          :fullname,
          :email,
          :phone_number,
          :residential_host,
          :residential_pet,
          :user_research,
          :property_one_line_1,
          :property_one_line_2,
          :property_one_town,
          :property_one_postcode
        )
  end
end
