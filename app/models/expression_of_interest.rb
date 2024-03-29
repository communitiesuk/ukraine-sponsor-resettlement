require "securerandom"

class ExpressionOfInterest < ApplicationRecord
  include ExpressionOfInterestValidations

  self.table_name = "expressions_of_interest"

  SCHEMA_VERSION = 4

  attr_accessor :fullname,
                :email,
                :phone_number,
                :residential_line_1,
                :residential_line_2,
                :residential_town,
                :residential_postcode,
                :different_address_types,
                :different_address,
                :property_one_line_1,
                :property_one_line_2,
                :property_one_town,
                :property_one_postcode,
                :more_properties_types,
                :more_properties,
                :more_properties_statement,
                :number_adults,
                :number_children,
                :family_types,
                :family_type,
                :host_as_soon_as_possible,
                :hosting_start_date,
                :accommodation_length_types,
                :accommodation_length,
                :single_room_count,
                :double_room_count,
                :step_free_types,
                :step_free,
                :allow_pet_types,
                :allow_pet,
                :agree_future_contact,
                :user_research_types,
                :user_research,
                :agree_privacy_statement,
                :postcode,
                :living_space,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :partial_validation

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @family_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @accommodation_length_types = %i[from_6_to_9_months from_10_to_12_months more_than_12_months from_6_months]
    @different_address_types = %i[yes no]
    @more_properties_types = %i[yes no]
    @step_free_types = %i[all some none unknown]
    @allow_pet_types = %i[affirmative negative]
    @allow_eoi_pet_types = %i[yes no]
    @host_as_soon_as_possible_types = %i[true false]
    @user_research_types = %i[yes no]
    @postcode = "not asked"
    @living_space = "rooms_in_home_shared_facilities"
    @accommodation_length = "from_6_months"
    @partial_validation = []
  end

  def hosting_start_date_as_string
    if @host_as_soon_as_possible == "true"
      "As soon as possible"
    elsif @hosting_start_date.present?
      Date.new(
        @hosting_start_date["1"].to_i,
        @hosting_start_date["2"].to_i,
        @hosting_start_date["3"].to_i,
      ).strftime("%d %B %Y")
    else
      ""
    end
  end

  def as_json
    {
      id:,
      reference:,
      created_at:,
      type:,
      version:,
      fullname:,
      email:,
      phone_number:,
      residential_line_1:,
      residential_line_2:,
      residential_town:,
      residential_postcode:,
      different_address:,
      property_one_line_1:,
      property_one_line_2:,
      property_one_town:,
      property_one_postcode:,
      more_properties:,
      number_adults:,
      number_children:,
      family_type:,
      accommodation_length:,
      host_as_soon_as_possible:,
      hosting_start_date:,
      single_room_count:,
      double_room_count:,
      step_free:,
      allow_pet:,
      agree_future_contact:,
      user_research:,
      agree_privacy_statement:,
      postcode:,
      ip_address:,
      user_agent:,
      started_at:,
    }.compact
  end

private

  def serialize
    self.type = "eoi-v2"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("EOI-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
