require "securerandom"

class IndividualExpressionOfInterest < ApplicationRecord
  self.table_name = "individual_expressions_of_interest"

  SCHEMA_VERSION = 1

  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/
  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  attr_accessor :family_types, :living_space_types, :step_free_types, :accommodation_length_types,
                :family_type, :living_space, :step_free, :accommodation_length, :single_room_count,
                :double_room_count, :postcode, :phone_number, :agree_future_contact, :agree_privacy_statement,
                :fullname, :email, :type, :version

  validate :validate_family_type, if: :family_type

  validate :validate_living_space_type, if: :living_space

  validate :validate_mobility_impairments_type, if: :step_free

  validate :validate_mobility_impairments_type, if: :step_free

  validates :single_room_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :double_room_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :postcode, allow_nil: true, length: { minimum: 2 }

  validate :validate_accommodation_length_type, if: :accommodation_length

  validate :validate_fullname, if: :fullname

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, allow_nil: true

  validate :validate_phone_number, if: :phone_number

  validates :agree_future_contact, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, allow_nil: true

  validates :agree_privacy_statement, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, allow_nil: true

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @family_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @living_space_types = %i[rooms_in_home_shared_facilities self_contained_property multiple_properties]
    @step_free_types = %i[yes_all yes_some no dont_know]
    @accommodation_length_types = %i[from_6_to_9_months from_10_to_12_months more_than_12_months]
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
    }.compact
  end

private

  def validate_family_type
    validate_enum(@family_types, @family_type, :family_type)
  end

  def validate_living_space_type
    validate_enum(@living_space_types, @living_space, :living_space)
  end

  def validate_mobility_impairments_type
    validate_enum(@step_free_types, @step_free, :step_free)
  end

  def validate_enum(enum, value, attribute)
    unless enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_accommodation_length_type
    unless @accommodation_length_types.include?(@accommodation_length.to_sym)
      errors.add(:accommodation_length, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_fullname
    unless @fullname.nil? || ((@fullname.split.length >= 2) && (@fullname.strip.length >= 3))
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def validate_phone_number
    if !@phone_number.nil? && !((@phone_number =~ /[0-9 -+]+$/) &&
      ((@phone_number.scan(/\d/).join.length >= MIN_PHONE_DIGITS) && (@phone_number.scan(/\d/).join.length <= MAX_PHONE_DIGITS)))
      errors.add(:phone_number, I18n.t(:invalid_phone_number, scope: :error))
    end
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
