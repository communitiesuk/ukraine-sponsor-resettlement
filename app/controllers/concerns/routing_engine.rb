class RoutingEngine
  def self.get_next_additional_info_step(application, current_step)
    if application.different_address.present? && application.different_address.casecmp("NO").zero? && current_step == 5
      9
    elsif application.more_properties.present? && application.more_properties.casecmp("NO").zero? && current_step == 7
      9
    else
      current_step + 1
    end
  end
end
