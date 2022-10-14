class IndexController < ApplicationController
  def index
    @feature_eoi_journey_enabled = (ENV["FEATURE_EOI_JOURNEY_ENABLED"] == "true")
  end
end
