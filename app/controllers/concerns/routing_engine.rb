class RoutingEngine
  def self.get_next_step(application, current_step)
    if application.different_address.present? && application.different_address.casecmp("YES").zero? && current_step == 5
      7
    elsif application.different_address.present? && application.different_address.casecmp("NO").zero? && current_step == 6
      11
    elsif application.more_properties.present? && application.more_properties.casecmp("NO").zero? && current_step == 9
      11
    else
      current_step + 1
    end
  end
end
