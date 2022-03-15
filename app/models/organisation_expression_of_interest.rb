class OrganisationExpressionOfInterest < ApplicationRecord
  self.table_name = "organisation_expressions_of_interest"

  SCHEMA_VERSION = 1

  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  attr_accessor :family_types, :living_space_types, :step_free_types, :agree_future_contact_types,
                :family_type, :living_space, :step_free, :property_count, :single_room_count,
                :double_room_count, :postcode, :organisation_name, :organisation_type, :agree_future_contact,
                :phone_number, :agree_privacy_statement, :type, :version

  validate :validate_family_type, if: :family_type
  validate :validate_living_space, if: :living_space
  validate :validate_step_free, if: :step_free
  validates :property_count, allow_nil: true, numericality: { only_integer: true }
  validates :single_room_count, allow_nil: true, numericality: { only_integer: true }
  validates :double_room_count, allow_nil: true, numericality: { only_integer: true }
  validates :postcode, allow_nil: true, length: { minimum: 2 }
  validates :organisation_name, allow_nil: true, length: { minimum: 2 }
  validates :organisation_type, allow_nil: true, length: { minimum: 2 }
  validate :validate_answer_more_questions, if: :agree_future_contact
  validate :validate_fullname, if: :fullname
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, allow_nil: true
  validate :validate_phone_number, if: :phone_number
  validates :agree_privacy_statement, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, allow_nil: true

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
    }.compact
  end

private

  def validate_family_type
    validate_enum(@family_types, @family_type, :family_type)
  end

  def validate_living_space
    validate_enum(@living_space_types, @living_space, :living_space)
  end

  def validate_step_free
    validate_enum(@step_free_types, @step_free, :step_free)
  end

  def validate_answer_more_questions
    validate_enum(@agree_future_contact_types, @agree_future_contact, :agree_future_contact)
  end

  def validate_enum(enum, value, attribute)
    unless enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_fullname
    unless fullname.nil? || ((fullname.split.length >= 2) && (fullname.length >= 3))
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
    self.type = "organisation"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("ANON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
