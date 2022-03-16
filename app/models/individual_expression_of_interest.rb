require "securerandom"

class IndividualExpressionOfInterest < ApplicationRecord
  self.table_name = "individual_expressions_of_interest"

  SCHEMA_VERSION = 2

  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/
  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  attr_accessor :family_types, :living_space_types, :step_free_types, :accommodation_length_types,
                :family_type, :step_free, :accommodation_length, :single_room_count,
                :double_room_count, :postcode, :phone_number, :agree_future_contact, :agree_privacy_statement,
                :fullname, :email, :type, :version, :ip_address, :user_agent, :started_at, :final_submission
  attr_reader   :living_space

  validate :validate_family_type, if: -> { run_validation? :family_type }
  validate :validate_living_space, if: -> { run_validation? :living_space }
  validate :validate_step_free, if: -> { run_validation? :step_free }
  validates :single_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t(:invalid_number, scope: :error) }, if: -> { run_validation? :single_room_count }
  validates :double_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t(:invalid_number, scope: :error) }, if: -> { run_validation? :double_room_count }
  validates :postcode, length: { minimum: 2, maximum: 100, message: I18n.t(:invalid_postcode, scope: :error) }, if: -> { run_validation? :postcode }
  validate :validate_accommodation_length, if: -> { run_validation? :accommodation_length }
  validate :validate_fullname, if: -> { run_validation? :fullname }
  validates :email, length: { maximum: 128, message: I18n.t(:invalid_email, scope: :error) }, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, if: -> { run_validation? :email }
  validate :validate_phone_number, if: -> { run_validation? :phone_number }
  validates :agree_future_contact, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, if: -> { run_validation? :agree_future_contact }
  validates :agree_privacy_statement, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, if: -> { run_validation? :agree_privacy_statement }

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

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end

  def validate_family_type
    validate_enum(@family_types, @family_type, :family_type)
  end

  def validate_living_space
    if living_space.nil? || @living_space.length.zero?
      errors.add(:living_space, I18n.t(:choose_one_or_more_options, scope: :error))
    end
  end

  def validate_step_free
    validate_enum(@step_free_types, @step_free, :step_free)
  end

  def validate_accommodation_length
    validate_enum(@accommodation_length_types, @accommodation_length, :accommodation_length)
  end

  def validate_enum(enum, value, attribute)
    unless value && enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_fullname
    unless @fullname && @fullname.split.length >= 2 && @fullname.strip.length >= 3 && fullname.length <= 128
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def validate_phone_number
    if @phone_number.blank? ||
        !((@phone_number =~ /[0-9 -+]+$/) &&
        ((@phone_number.scan(/\d/).join.length >= MIN_PHONE_DIGITS) &&
        (@phone_number.scan(/\d/).join.length <= MAX_PHONE_DIGITS))) ||
        @phone_number.length > MAX_PHONE_DIGITS * 2
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
