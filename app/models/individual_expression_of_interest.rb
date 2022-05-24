require "securerandom"

class IndividualExpressionOfInterest < ApplicationRecord
  include IndividualValidations

  self.table_name = "individual_expressions_of_interest"

  SCHEMA_VERSION = 3

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
                :accommodation_length_types,
                :accommodation_length,
                :single_room_count,
                :double_room_count,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission
  attr_reader   :living_space

  validate :validate_different_address, if: -> { run_validation? :different_address }
  validate :validate_accommodation_length, if: -> { run_validation? :accommodation_length }
  validate :validate_more_properties, if: -> { run_validation? :more_properties }
  validate :validate_number_adults, if: -> { run_validation? :number_adults }
  validates :number_children, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9, message: I18n.t(:number_children, scope: :error) }, if: -> { run_validation? :number_children }

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
      single_room_count:,
      double_room_count:,
      ip_address:,
      user_agent:,
      started_at:,
    }.compact
  end

private

  def validate_different_address
    validate_enum(@different_address_types, @different_address, :different_address)
  end

  def validate_more_properties
    validate_enum(@more_properties_types, @more_properties, :more_properties)
  end

  def validate_accommodation_length
    validate_enum(@accommodation_length_types, @accommodation_length, :accommodation_length)
  end

  def validate_number_adults
    @is_residential_property    = different_address.present? && different_address.casecmp("NO").zero?
    @is_number_adults_integer   = is_integer?(@number_adults)
    @is_number_children_integer = is_integer?(number_children)

    if @is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_one, scope: :error))
    elsif @is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero?
      errors.add(:number_adults, I18n.t(:number_adults_residential, scope: :error))
    elsif !@is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_zero, scope: :error))
    elsif !@is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero? && @is_number_children_integer && number_children.to_i.positive?
      errors.add(:number_adults, I18n.t(:child_without_adult, scope: :error))
    end
  end

  def is_integer?(value)
    true if Integer(value, exception: false)
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
