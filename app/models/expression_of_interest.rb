require "securerandom"

class ExpressionOfInterest < ApplicationRecord
  include ExpressionOfInterestValidations
  include ContactDetailsValidations
  include CommonValidations

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
                :number_adults,
                :number_children,
                :family_types,
                :family_type,
                :hosting_start_date,
                :hosting_start_date_as_string,
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
                :final_submission

  validate :validate_different_address, if: -> { run_validation? :different_address }
  validate :validate_accommodation_length, if: -> { run_validation? :accommodation_length }
  validate :validate_more_properties, if: -> { run_validation? :more_properties }
  validate :validate_number_adults, if: -> { run_validation? :number_adults }
  validates :number_children, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9, message: I18n.t(:number_children, scope: :error) }, if: -> { run_validation? :number_children }
  validate :validate_allow_pet_pet, if: -> { run_validation? :allow_pet }
  validate :validate_user_research, if: -> { run_validation? :user_research }

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @family_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @accommodation_length_types = %i[from_6_to_9_months from_10_to_12_months more_than_12_months]
    @final_submission = false
    @different_address_types = %i[yes no]
    @more_properties_types = %i[yes no]
    @step_free_types = %i[all some none unknown]
    @allow_pet_types = %i[yes no]
    @user_research_types = %i[yes no]
    @postcode = "not asked"
    @living_space = "rooms_in_home_shared_facilities"
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

  def validate_accommodation_length
    validate_enum(@accommodation_length_types, @accommodation_length, :accommodation_length)
  end

  def serialize
    self.type = "eoi-v2"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("EOI-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
