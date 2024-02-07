class UamWorkflow
  @states = {
    "1" => { actions: [{ action: :go_next, destination: "2" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/1"  },
    "2" => { actions: [{ action: :go_next, destination: "3" }, { action: :skip_next, destination: "4" }],
             view_name: "sponsor-a-child/steps/2"  },
    "3" => { actions: [{ action: :go_next, destination: "4" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/3"  },
    "4" => { actions: [{ action: :go_next, destination: "5" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/4"  },
    "5" => { actions: [{ action: :go_next, destination: "6" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/5"  },
    "6" => { actions: [{ action: :go_next, destination: "7" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/6"  },
    "7" => { actions: [{ action: :go_next, destination: "9" }, { action: :not_eligible, destination: "non-eligible" }],
             view_name: "sponsor-a-child/steps/7"  },
    "9" => { actions: [{ action: :go_next, destination: "10" }],
             view_name: "sponsor-a-child/steps/9"  },
    "10" => { actions: [{ action: :go_next, destination: "11" }],
              view_name: "sponsor-a-child/steps/10"  },
    "11" => { actions: [{ action: :go_next, destination: "12" }, { action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/11"  },
    "12" => { actions: [{ action: :go_next, destination: "13" }],
              view_name: "sponsor-a-child/steps/12"  },
    "13" => { actions: [{ action: :go_next, destination: "14" }, { action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/13",
              tags: %i[other_names_summary] },
    "14" => { actions: [{ action: :go_next, destination: "15" }],
              view_name: "sponsor-a-child/steps/14",
              tags: %i[save_and_return_1] },
    "15" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/15",
              tags: %i[save_and_return_2] },
    "16" => { actions: [{ action: :go_next, destination: "17" }, { action: :skip_next, destination: "18" }],
              view_name: "sponsor-a-child/steps/16",
              tags: %i[sponsor_id_type] },
    "17" => { actions: [{ action: :go_next, destination: "18" }],
              view_name: "sponsor-a-child/steps/17"  },
    "18" => { actions: [{ action: :go_next, destination: "19" }],
              view_name: "sponsor-a-child/steps/18"  },
    "19" => { actions: [{ action: :go_next, destination: "20" }],
              view_name: "sponsor-a-child/steps/19",
              tags: %i[nationality_step] },
    "20" => { actions: [{ action: :go_next, destination: "21" }, { action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/20" },
    "21" => { actions: [{ action: :go_next, destination: "22" }],
              view_name: "sponsor-a-child/steps/21",
              tags: %i[nationality_step other_nationality] },
    "22" => { actions: [{ action: :go_next, destination: "23" }, { action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/22",
              tags: %i[nationalities_summary] },
    "23" => { actions: [{ action: :go_next, destination: "24" }],
              view_name: "sponsor-a-child/steps/23"  },
    "24" => { actions: [{ action: :skip_next, destination: "26" }, { action: :go_residents, destination: "28" }, { action: :go_next, destination: "25" }],
              view_name: "sponsor-a-child/steps/24"  },
    "25" => { actions: [{ action: :go_task_list, destination: "task-list" }, { action: :skip_next, destination: "27" }],
              view_name: "sponsor-a-child/steps/25"  },
    "26" => { actions: [{ action: :go_next, destination: "27" }],
              view_name: "sponsor-a-child/steps/26"  },
    "27" => { actions: [{ action: :go_next, destination: "28" }],
              view_name: "sponsor-a-child/steps/27",
              tags: %i[adults_at_address] },
    "28" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/28",
              tags: %i[adult_summary] },
    "29" => { actions: [{ action: :go_next, destination: "30" }],
              view_name: "sponsor-a-child/steps/29",
              tags: %i[adult_step] },
    "30" => { actions: [{ action: :go_next, destination: "31" }],
              tags: %i[adult_step nationality_step],
              view_name: "sponsor-a-child/steps/30" },
    "31" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              tags: %i[adult_step],
              view_name: "sponsor-a-child/steps/31" },
    "32" => { actions: [{ action: :go_next, destination: "33" }],
              view_name: "sponsor-a-child/steps/32"  },
    "33" => { actions: [{ action: :go_next, destination: "34" }],
              view_name: "sponsor-a-child/steps/33"  },
    "34" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/34"  },
    "35" => { actions: [{ action: :go_next, destination: "36" }],
              view_name: "sponsor-a-child/steps/35"  },
    "36" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/36"  },
    "37" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/37"  },
    "38" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/38"  },
    "39" => { actions: [{ action: :go_task_list, destination: "task-list" }],
              view_name: "sponsor-a-child/steps/39"  },
  }

  @actions_map = {
    "1" => lambda do |uam_instance|
      if uam_instance.is_under_18.casecmp("yes").zero?
        :go_next
      elsif uam_instance.is_under_18.casecmp("no").zero?
        :not_eligible
      end
    end,
    "2" => lambda do |uam_instance|
      if uam_instance.is_living_december.casecmp("yes").zero?
        :skip_next
      elsif uam_instance.is_living_december.casecmp("no").zero?
        :go_next
      end
    end,
    "3" => lambda do |uam_instance|
      if uam_instance.is_born_after_december.casecmp("yes").zero?
        :go_next
      elsif uam_instance.is_born_after_december.casecmp("no").zero?
        :not_eligible
      end
    end,
    "4" => lambda do |uam_instance|
      if uam_instance.is_unaccompanied.casecmp("yes").zero?
        :not_eligible
      elsif uam_instance.is_unaccompanied.casecmp("no").zero?
        :go_next
      end
    end,
    "5" => lambda do |uam_instance|
      if uam_instance.is_consent.casecmp("yes").zero?
        :go_next
      elsif uam_instance.is_consent.casecmp("no").zero?
        :not_eligible
      end
    end,
    "6" => lambda do |uam_instance|
      if uam_instance.is_committed.casecmp("yes").zero?
        :go_next
      elsif uam_instance.is_committed.casecmp("no").zero?
        :not_eligible
      end
    end,
    "7" => lambda do |uam_instance|
      if uam_instance.is_permitted.casecmp("yes").zero?
        :go_next
      elsif uam_instance.is_permitted.casecmp("no").zero?
        :not_eligible
      end
    end,
    "9" => :go_next,
    "10" => :go_next,
    "11" => lambda do |uam_instance|
      if uam_instance.has_other_names.casecmp("true").zero?
        :go_next
      elsif uam_instance.has_other_names.casecmp("false").zero?
        :go_task_list
      end
    end,
    "12" => :go_next,
    "13" => lambda do |uam_instance|
      if uam_instance.has_other_names.casecmp("true").zero?
        :go_task_list
      elsif uam_instance.has_other_names.casecmp("false").zero?
        :go_next
      end
    end,
    "14" => :go_next,
    "15" => :go_task_list,
    "16" => lambda do |uam_instance|
      if uam_instance.identification_type.present? && !uam_instance.identification_type.casecmp("none").zero?
        :skip_next
      else
        :go_next
      end
    end,
    "17" => :go_next,
    "18" => :go_next,
    "19" => :go_next,
    "20" => lambda do |uam_instance|
      if uam_instance.has_other_nationalities.casecmp("true").zero?
        :go_next
      elsif uam_instance.has_other_nationalities.casecmp("false").zero?
        :go_task_list
      end
    end,
    "21" => :go_next,
    "22" => lambda do |uam_instance|
      if uam_instance.has_other_nationalities.casecmp("true").zero?
        :go_task_list
      elsif uam_instance.has_other_nationalities.casecmp("false").zero?
        :go_next
      end
    end,
    "23" => :go_next,
    "24" => lambda do |uam_instance|
      if uam_instance.different_address.casecmp("no").zero?
        :skip_next
      elsif uam_instance.adults_at_address.present? && !uam_instance.adults_at_address.empty?
        :go_residents
      else
        :go_next
      end
    end,
    "25" => lambda do |uam_instance|
      if uam_instance.other_adults_address.casecmp("yes").zero?
        :skip_next
      elsif uam_instance.other_adults_address.casecmp("no").zero?
        :go_task_list
      end
    end,
    "26" => :go_next,
    "27" => :go_next,
    "28" => :go_task_list,
    "29" => :go_next,
    "30" => :go_next,
    "31" => :go_task_list,
    "32" => :go_next,
    "33" => :go_next,
    "34" => :go_task_list,
    "35" => :go_next,
    "36" => :go_task_list,
    "37" => :go_task_list,
    "38" => :go_task_list,
    "39" => :go_task_list,
  }

  @data_transforms = {
    "12" => lambda do |uam_instance, _params|
      (uam_instance.other_names ||= []) << [uam_instance.other_given_name.strip, uam_instance.other_family_name.strip]
    end,
    "16" => lambda do |uam_instance, params|
      uam_instance.identification_type = if params["unaccompanied_minor"].key?("identification_type")
                                           params["unaccompanied_minor"]["identification_type"]
                                         else
                                           ""
                                         end

      uam_instance.identification_number = case uam_instance.identification_type
                                           when "passport"
                                             params["unaccompanied_minor"]["passport_identification_number"]
                                           when "national_identity_card"
                                             params["unaccompanied_minor"]["id_identification_number"]
                                           when "biometric_residence"
                                             params["unaccompanied_minor"]["biometric_residence_identification_number"]
                                           when "photo_driving_licence"
                                             params["unaccompanied_minor"]["photo_driving_licence_identification_number"]
                                           else
                                             ""
                                           end
    end,
    "21" => lambda do |uam_instance, params|
      (uam_instance.other_nationalities ||= []) << [params["unaccompanied_minor"]["other_nationality"]]
    end,
    "27" => lambda do |uam_instance, params|
      if !params["unaccompanied_minor"]["adult_given_name"].empty? && !params["unaccompanied_minor"]["adult_family_name"].empty?
        uam_instance.adults_at_address = {} if uam_instance.adults_at_address.nil?
        uam_instance.adults_at_address.store(SecureRandom.uuid.upcase.to_s, Adult.new(params["unaccompanied_minor"]["adult_given_name"], params["unaccompanied_minor"]["adult_family_name"]))
      end
    end,
    "29" => lambda do |uam_instance, params|
      uam_instance.adults_at_address[params["key"]]["date_of_birth"] = Date.new(params["unaccompanied_minor"]["adult_date_of_birth(1i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(2i)"].to_i, params["unaccompanied_minor"]["adult_date_of_birth(3i)"].to_i)
    end,
    "30" => lambda do |uam_instance, params|
      @adult = uam_instance.adults_at_address[params["key"]]
      @adult["nationality"] = params["unaccompanied_minor"]["adult_nationality"]
    end,
    "31" => lambda do |uam_instance, params|
      @adult = uam_instance.adults_at_address[params["key"]]
      id_type = params["unaccompanied_minor"]["adult_identification_type"]
      document_id = nil
      case id_type
      when "passport"
        document_id = params["unaccompanied_minor"]["adult_passport_identification_number"]
      when "national_identity_card"
        document_id = params["unaccompanied_minor"]["adult_id_identification_number"]
      when "biometric_residence"
        document_id = params["unaccompanied_minor"]["adult_biometric_residence_identification_number"]
      when "photo_driving_licence"
        document_id = params["unaccompanied_minor"]["adult_photo_driving_licence_identification_number"]
      end
      @adult["id_type_and_number"] = "#{id_type} - #{document_id || '123456789'}"
    end,
    "33" => lambda do |uam_instance, _params|
      uam_instance.minor_contact_type = uam_instance.minor_contact_type.reject(&:empty?)
      if uam_instance.minor_contact_type.include?("none")
        uam_instance.minor_email = ""
        uam_instance.minor_email_confirm = ""
        uam_instance.minor_phone_number = ""
        uam_instance.minor_phone_number_confirm = ""
      end
      unless uam_instance.minor_contact_type.include?("telephone")
        uam_instance.minor_phone_number = ""
        uam_instance.minor_phone_number_confirm = ""
      end
      unless uam_instance.minor_contact_type.include?("email")
        uam_instance.minor_email = ""
        uam_instance.minor_email_confirm = ""
      end
    end,
  }

  class << self
    # A bit of laziness to put off writing helper methods such as
    # is_valid_state?
    # get_state_index
    # etc
    attr_reader :states
  end

  def self.do_data_transforms(current_state, uam_instance, params)
    if @data_transforms.key?(current_state)
      transformproc = @data_transforms[current_state]
      transformproc.call(uam_instance, params)
    end
  end

  def self.get_action_from_submit(current_state_name, eoi_instance)
    if @actions_map.key?(current_state_name)
      if @actions_map[current_state_name].instance_of?(::Proc)
        @actions_map[current_state_name].call(eoi_instance)
      elsif @actions_map[current_state_name].instance_of?(::Symbol)
        @actions_map[current_state_name]
      end
    end
  end

  def self.get_next_step(current_state, uam_instance)
    action = get_action_from_submit(current_state, uam_instance)
    state_table_entry_actions = @states[current_state][:actions]
    state_table_entry_actions.each do |state_table_entry_action|
      if state_table_entry_action[:action] == action
        return state_table_entry_action[:destination]
      end
    end
    nil
  end

  def self.state_has_tag(state, tag)
    @states[state].fetch(:tags, []).include?(tag)
  end

  def self.find_by_tag(tag)
    @states.each_key do |state_name|
      if state_has_tag(state_name, tag)
        return state_name
      end
    end
  end
end
