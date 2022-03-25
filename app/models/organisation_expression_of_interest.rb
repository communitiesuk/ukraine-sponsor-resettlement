class OrganisationExpressionOfInterest < ApplicationRecord
  include CommonValidations

  self.table_name = "organisation_expressions_of_interest"

  SCHEMA_VERSION = 2

  attr_accessor :family_types, :living_space_types, :step_free_types, :agree_future_contact_types, :organisation_types,
                :family_type, :step_free, :property_count, :single_room_count,
                :double_room_count, :postcode, :organisation_name, :organisation_type, :agree_future_contact, :fullname,
                :phone_number, :agree_privacy_statement, :type, :version, :ip_address, :user_agent, :started_at,
                :organisation_type_business_information, :organisation_type_other_information, :final_submission

  attr_reader   :living_space

  validate :validate_organisation_type, if: -> { run_validation? :organisation_type }
  validate :validate_organisation_name, if: -> { run_validation? :organisation_name }
  validates :property_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t(:invalid_number, scope: :error) }, if: -> { run_validation? :property_count }
  validates :organisation_type_business_information, allow_nil: true, length: { maximum: 500, message: I18n.t(:max_500_chars, scope: :error) }
  validates :organisation_type_other_information, allow_nil: true, length: { maximum: 500, message: I18n.t(:max_500_chars, scope: :error) }

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @family_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @living_space_types = %i[rooms_in_property rooms_in_multiple_properties self_contained_property multiple_properties]
    @step_free_types = %i[all some none unknown]
    @agree_future_contact_types = %i[yes no]
    @organisation_types = %i[charity faith business other]
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
      property_count:,
      single_room_count:,
      double_room_count:,
      postcode:,
      organisation_name:,
      organisation_type:,
      agree_future_contact:,
      fullname:,
      email:,
      phone_number:,
      agree_privacy_statement:,
      ip_address:,
      user_agent:,
      started_at:,
      organisation_type_business_information:,
      organisation_type_other_information:,
    }.compact
  end

  def living_space=(value)
    @living_space = value.is_a?(Array) ? value.reject(&:empty?) : value
  end

private

  def validate_organisation_type
    validate_enum(@organisation_types, @organisation_type, :organisation_type)

    self.organisation_type_business_information = nil unless @organisation_type == "business"
    self.organisation_type_other_information = nil unless @organisation_type == "other"
  end

  def validate_organisation_name
    if @organisation_name.length < 2 || @organisation_name.length > 100 || @organisation_name.match(/[!"£$%{}<>|@\/()=?^]/)
      errors.add(:organisation_name, I18n.t(:invalid_organisation_name, scope: :error))
    end
  end

  def serialize
    self.type = "organisation"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("ANON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
