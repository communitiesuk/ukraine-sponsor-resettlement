class IndexController < ApplicationController
  def index
    @feature_eoi_journey_enabled = (ENV["FEATURE_EOI_JOURNEY_ENABLED"] == "true")
    if ENV["FEATURE_EOI_JOURNEY_ENABLED"] == "true"
      render "index/index_eoi"
    else
      render "index/index"
    end
  end
end
