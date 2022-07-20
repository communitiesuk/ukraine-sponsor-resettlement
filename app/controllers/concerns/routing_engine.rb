class RoutingEngine
  TASK_LIST_STEP = 999
  NOT_ELIGIBLE = -1

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
    if application.is_under_18.present? && application.is_under_18.casecmp("no").zero? && current_step == 1
      NOT_ELIGIBLE
    elsif application.is_living_december.present? && application.is_living_december.casecmp("yes").zero? && current_step == 2
      4
    elsif application.is_born_after_december.present? && application.is_born_after_december.casecmp("no").zero? && current_step == 3
      NOT_ELIGIBLE
    elsif application.is_eligible.present? && application.is_eligible.casecmp("true").zero? && current_step == 6
      8
    elsif application.identification_type.present? && !application.identification_type.casecmp("none").zero? && current_step == 16
      18
    elsif application.different_address.present? && application.different_address.casecmp("no").zero? && current_step == 24
      26
    elsif application.other_adults_address.present? && application.other_adults_address.casecmp("yes").zero? && current_step == 25
      27
    elsif application.has_other_names.present? && application.has_other_names.casecmp("false").zero? && current_step == 11
      TASK_LIST_STEP
    elsif application.has_other_names.present? && application.has_other_names.casecmp("true").zero? && current_step == 13
      TASK_LIST_STEP
    elsif application.phone_number.present? && current_step == 15
      TASK_LIST_STEP
    elsif application.has_other_nationalities.present? && application.has_other_nationalities.casecmp("false").zero? && current_step == 20
      TASK_LIST_STEP
    elsif application.has_other_nationalities.present? && application.has_other_nationalities.casecmp("true").zero? && current_step == 22
      TASK_LIST_STEP
    elsif application.ukraine_parental_consent_filename.present? && current_step == 35
      TASK_LIST_STEP
    elsif application.other_adults_address.present? && application.other_adults_address.casecmp("no").zero? && current_step == 25
      TASK_LIST_STEP
    # elsif application.is_eligible.present? && application.is_eligible.casecmp("false").zero? && [, 4, 5, 7, 8].include?(current_step)
    #   # this needs to be the last check we do; returns the non-eligible path (excluding steps  and 6)
    #   -1
    else
      current_step + 1
    end
  end
end
