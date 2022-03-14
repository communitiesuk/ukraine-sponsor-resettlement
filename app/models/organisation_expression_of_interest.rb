class OrganisationExpressionOfInterest < ApplicationRecord
  self.table_name = "organisation_expressions_of_interest"

  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  attr_accessor :sponsor_types, :sponsor_type, :living_space_types, :living_space, :step_free_types, :step_free, :property_count, :single_room_count, :double_room_count, :postcode, :organisation_name, :organisation_type, :answer_more_questions_types, :answer_more_questions, :phone_number, :privacy

  validate :validate_sponsor_type, if: :sponsor_type
  validate :validate_living_space, if: :living_space
  validate :validate_step_free, if: :step_free
  validates :property_count, allow_nil: true, numericality: { only_integer: true }
  validates :single_room_count, allow_nil: true, numericality: { only_integer: true }
  validates :double_room_count, allow_nil: true, numericality: { only_integer: true }
  validates :postcode, allow_nil: true, length: { minimum: 2 }
  validates :organisation_name, allow_nil: true, length: { minimum: 2 }
  validates :organisation_type, allow_nil: true, length: { minimum: 2 }
  validate :validate_answer_more_questions, if: :answer_more_questions
  validate :validate_fullname, if: :fullname
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, allow_nil: true
  validate :validate_phone_number, if: :phone_number

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @sponsor_types = %i[single_adult more_than_one_adult adults_with_children no_preference]
    @living_space_types = %i[rooms_in_property rooms_in_multiple_properties self_contained_property multiple_properties]
    @step_free_types = %i[all some none unknown]
    @answer_more_questions_types = %i[yes no]
  end

  def as_json
    {
      sponsor_type:,
      living_space:,
      step_free:,
      property_count:,
      single_room_count:,
      double_room_count:,
      postcode:,
      organisation_name:,
      organisation_type:,
      answer_more_questions:,
      fullname:,
      email:,
      phone_number:,
      privacy:,
    }.compact
  end

private

  def validate_sponsor_type
    unless @sponsor_types.include?(@sponsor_type.to_sym)
      errors.add(:sponsor_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_living_space
    unless @living_space_types.include?(@living_space.to_sym)
      errors.add(:living_space, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_step_free
    unless @step_free_types.include?(@step_free.to_sym)
      errors.add(:step_free, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_answer_more_questions
    unless @answer_more_questions_types.include?(@answer_more_questions.to_sym)
      errors.add(:answer_more_questions, I18n.t(:choose_option, scope: :error))
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
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= SecureRandom.base64(99).gsub!(/[+=\/]/, "")[0, 10].downcase
  end
end
