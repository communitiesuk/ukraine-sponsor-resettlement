require "securerandom"

class IndividualExpressionOfInterest < ApplicationRecord
  include CommonValidations

  self.table_name = "individual_expressions_of_interest"

  SCHEMA_VERSION = 2

  attr_accessor :family_types, :living_space_types, :step_free_types, :accommodation_length_types,
                :family_type, :step_free, :accommodation_length, :single_room_count,
                :double_room_count, :postcode, :phone_number, :agree_future_contact, :agree_privacy_statement,
                :fullname, :email, :type, :version, :ip_address, :user_agent, :started_at, :final_submission
  attr_reader   :living_space

  validate :validate_accommodation_length, if: -> { run_validation? :accommodation_length }

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @family_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @living_space_types = %i[rooms_in_home_shared_facilities self_contained_property multiple_properties]
    @step_free_types = %i[all some none unknown]
    @accommodation_length_types = %i[from_6_to_9_months from_10_to_12_months more_than_12_months]
    @final_submission = false
  end

  def as_json
    {
      id:,
      reference:,
      created_at:,
      type:,
      version:,
      family_type:,
      living_space:,
      step_free:,
      single_room_count:,
      double_room_count:,
      postcode:,
      accommodation_length:,
      agree_future_contact:,
      fullname:,
      email:,
      phone_number:,
      agree_privacy_statement:,
      ip_address:,
      user_agent:,
      started_at:,
    }.compact
  end

  def living_space=(value)
    @living_space = value.is_a?(Array) ? value.reject(&:empty?) : value
  end

private

  def validate_accommodation_length
    validate_enum(@accommodation_length_types, @accommodation_length, :accommodation_length)
  end

  def serialize
    self.type = "individual"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("ANON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
