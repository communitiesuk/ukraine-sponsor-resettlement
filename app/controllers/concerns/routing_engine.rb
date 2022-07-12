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
    elsif application.has_other_names.present? && application.has_other_names.casecmp("false").zero? && current_step == 11
      # sponsor does not have other names
      14
    elsif application.identification_type.present? && !application.identification_type.casecmp("none").zero? && current_step == 16
      # sponsor has provided an identification document, jump to date of birth
      18
    elsif application.has_other_nationalities.present? && application.has_other_nationalities.casecmp("false").zero? && current_step == 20
      # sponsor does not have other nationalities
      0
    elsif application.is_eligible.present? && application.is_eligible.casecmp("false").zero? && [1,3,4,5,7,8].include?(current_step)
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
