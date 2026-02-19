require "uk_postcode"

class EoiWorkflow
  @states = {
    "1" => { actions: [{ action: :go_next, destination: "2" }],
             view_name: "eoi/steps/fullname",
             validations: [:fullname] },
    "2" => { actions: [{ action: :go_next, destination: "3" }],
             view_name: "eoi/steps/email",
             validations: [:email] },
    "3" => { actions: [{ action: :go_next, destination: "4" }],
             view_name: "eoi/steps/phone_number",
             validations: [:phone_number] },
    "4" => { actions: [{ action: :go_next, destination: "5" }],
             view_name: "eoi/steps/address",
             validations: %i[residential_line_1 residential_line_2 residential_town residential_postcode] },
    "5" => { actions: [
               { action: :go_diff_addr, destination: "6" },
               { action: :skip_diff_addr, destination: "9" },
               { action: :back_to_address, destination: "4" },
               { action: :redirect_wales, destination: "end" },
             ],
             view_name: "eoi/steps/different_address",
             validations: [:different_address] },
    "6" => { actions: [
               { action: :go_next, destination: "7" },
               { action: :reload, destination: "6" },
               { action: :redirect_wales, destination: "end" },
             ],
             view_name: "eoi/steps/property_one_address",
             validations: %i[property_one_line_1 property_one_line_2 property_one_town property_one_postcode] },
    "7" => { actions: [
               { action: :go_more_properties_statement, destination: "8" },
               { action: :skip_more_properties_statement, destination: "9" },
             ],
             view_name: "eoi/steps/more_properties",
             validations: [:more_properties] },
    "8" => { actions: [{ action: :go_next, destination: "9" }],
             view_name: "eoi/steps/more_properties_statement",
             validations: [] },
    "9" => { actions: [{ action: :go_next, destination: "10" }],
             view_name: "eoi/steps/hosting_start_date",
             validations: %i[host_as_soon_as_possible hosting_start_date] },
    "10" => { actions: [{ action: :go_next, destination: "11" }],
              view_name: "eoi/steps/number_people",
              validations: %i[number_adults number_children] },
    "11" => { actions: [{ action: :go_next, destination: "12" }],
              view_name: "eoi/steps/family_type",
              validations: [:family_type] },
    "12" => { actions: [{ action: :go_next, destination: "13" }],
              view_name: "eoi/steps/number_bedrooms",
              validations: %i[single_room_count double_room_count] },
    "13" => { actions: [{ action: :go_next, destination: "14" }],
              view_name: "eoi/steps/step_free",
              validations: [:step_free] },
    "14" => { actions: [{ action: :go_next, destination: "15" }],
              view_name: "eoi/steps/allow_pet",
              validations: [:allow_pet] },
    "15" => { actions: [{ action: :go_next, destination: "16" }],
              view_name: "eoi/steps/user_research",
              validations: [:user_research] },
    "16" => { actions: [{ action: :go_next, destination: "check-answers" }],
              view_name: "eoi/steps/privacy_statement",
              validations: [:agree_privacy_statement] },
    "end" => { actions: [],
               view_name: "eoi/steps/invalid_postcode",
               validations: [] },
  }

  @actions_map = {
    "1" => :go_next,
    "2" => :go_next,
    "3" => :go_next,
    "4" => :go_next,
    "5" => lambda do |params, eoi_instance|
      if params.key?("different_address") && params["different_address"].casecmp("yes").zero?
        :go_diff_addr
      elsif params.key?("different_address") && params["different_address"].casecmp("no").zero?
        if eoi_instance.residential_postcode
          pc = UKPostcode.parse(eoi_instance.residential_postcode)
          case pc.country
          when :england
            :skip_diff_addr
          when :northern_ireland
            :skip_diff_addr
          when :scotland
            :skip_diff_addr
          when :wales
            :redirect_wales
          else
            :skip_diff_addr
          end
        else
          :back_to_address
        end
      end
    end,
    "6" => lambda do |params, _eoi_instance|
      if params["property_one_postcode"]
        pc = UKPostcode.parse(params["property_one_postcode"])
        case pc.country
        when :england
          :go_next
        when :northern_ireland
          :go_next
        when :scotland
          :go_next
        when :wales
          :redirect_wales
        else
          :go_next
        end
      else
        :reload
      end
    end,
    "7" => lambda do |params, _eoi_instance|
      if params.key?("more_properties") && params["more_properties"].casecmp("yes").zero?
        :go_more_properties_statement
      elsif params.key?("more_properties") && params["more_properties"].casecmp("no").zero?
        :skip_more_properties_statement
      end
    end,
    "8" => :go_next,
    "9" => :go_next,
    "10" => :go_next,
    "11" => :go_next,
    "12" => :go_next,
    "13" => :go_next,
    "14" => :go_next,
    "15" => :go_next,
    "16" => :go_next,
  }

  class << self
    # A bit of laziness to put off writing helper methods such as
    # is_valid_state?
    # get_state_index
    # etc
    attr_reader :states
  end

  def self.get_action_from_submit(current_state_name, submitted_params, eoi_instance)
    if @actions_map.key?(current_state_name)
      if @actions_map[current_state_name].instance_of?(::Proc)
        @actions_map[current_state_name].call(submitted_params, eoi_instance)
      elsif @actions_map[current_state_name].instance_of?(::Symbol)
        @actions_map[current_state_name]
      end
    end
  end

  def self.get_next_step(current_state, submitted_params, eoi_instance)
    action = get_action_from_submit(current_state, submitted_params, eoi_instance)
    state_table_entry_actions = @states[current_state][:actions]
    state_table_entry_actions.each do |state_table_entry_action|
      if state_table_entry_action[:action] == action
        return state_table_entry_action[:destination]
      end
    end
  end
end
