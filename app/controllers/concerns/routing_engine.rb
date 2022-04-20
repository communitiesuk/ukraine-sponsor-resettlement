class RoutingEngine
  def self.get_next_step(application, current_step)
    if application.residential_host == "Yes" && current_step == 7
      999
    elsif application.residential_host == "No" && current_step == 5
      8
    else
      current_step + 1
    end
  end
end
