class UnaccompaniedController < ApplicationController
  MAX_STEPS = 1

  def display
    @application = UnaccompaniedMinor.new(session[:unaccompanied_minors])

    step = params["stage"].to_i

    if step.positive? && step <= MAX_STEPS
      render "unaccompanied-minor/steps/#{step}"
    else
      redirect_to "/unaccompanied-minor"
    end
  end

  def handle_step
    # TODO: implement step
  end
end
