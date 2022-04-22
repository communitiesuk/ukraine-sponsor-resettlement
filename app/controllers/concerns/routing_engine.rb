class RoutingEngine
  def self.get_next_step(application, current_step)
    if application.residential_host.present? && application.residential_host.upcase == "NO" && current_step == 5
      7
    elsif application.residential_host.present? && application.residential_host.upcase == "YES" && current_step == 6
      11
    elsif application.more_properties.present? && application.more_properties.upcase == "NO" && current_step == 9
      11
    else
      current_step + 1
    end
  end
end
