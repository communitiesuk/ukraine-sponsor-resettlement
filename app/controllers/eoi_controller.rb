class EoiController < ApplicationController
  def index; end

  def property_suitable
    render "eoi/steps/is_your_property_suitable"
  end

  def challenges
    render "eoi/steps/challenges"
  end
end
