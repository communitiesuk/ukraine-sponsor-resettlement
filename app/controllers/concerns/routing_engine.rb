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

  def self.get_next_individual_step(application, current_step)
    if application.different_address.present? && application.different_address.casecmp("NO").zero? && current_step == 5
      9
    elsif application.more_properties.present? && application.more_properties.casecmp("NO").zero? && current_step == 7
      9
    else
      current_step + 1
    end
  end

  def self.get_next_unaccompanied_minor_step(application, current_step)
    if application.is_eligible.present? && application.is_eligible.casecmp("true").zero? && current_step == 2
      4
    elsif application.is_eligible.present? && application.is_eligible.casecmp("true").zero? && current_step == 6
      8
    elsif application.is_eligible.present? && application.is_eligible.casecmp("false").zero? && ![2, 6].include?(current_step)
      # this needs to be the last check we do; returns the non-eligible path (excluding steps 2 and 6)
      -1
    else
      current_step + 1
    end

    # if application.have_parental_consent.present? && application.have_parental_consent.casecmp("YES").zero? && current_step == 3
    #  5
    # else
    #  current_step + 1
    # end
  end
end
