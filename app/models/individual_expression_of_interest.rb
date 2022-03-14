require "securerandom"

class IndividualExpressionOfInterest < ApplicationRecord
  self.table_name = "individual_expressions_of_interest"

  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/
  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  attr_accessor :sponsor_types, :family_or_single_types, :living_space_types, :mobility_impairments_types, :accommodation_length_types, :dbs_certificate_types, :answer_more_questions_types,
                :sponsor_type, :family_or_single_type, :living_space_type, :mobility_impairments_type, :accommodation_length_type, :dbs_certificate_type, :answer_more_questions_type, :single_room_count, :double_room_count, :postcode, :mobile_number

  validate :validate_sponsor_type, if: :sponsor_type

  validate :validate_family_or_single_type, if: :family_or_single_type

  validate :validate_living_space_type, if: :living_space_type

  validate :validate_mobility_impairments_type, if: :mobility_impairments_type

  validate :validate_mobility_impairments_type, if: :mobility_impairments_type

  validates :single_room_count, allow_nil: true, numericality: { only_integer: true }

  validates :double_room_count, allow_nil: true, numericality: { only_integer: true }

  validates :postcode, allow_nil: true, format: { message: I18n.t(:invalid_postcode, scope: :error), with: POSTCODE_REGEX }

  validate :validate_accommodation_length_type, if: :accommodation_length_type

  validate :validate_dbs_certificate_type, if: :dbs_certificate_type

  validate :validate_answer_more_questions_type, if: :answer_more_questions_type

  validate :validate_fullname, if: :fullname

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, allow_nil: true

  validate :validate_mobile_number, if: :mobile_number

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @sponsor_types = %i[family_member friend_or_colleague unknown_person]
    @family_or_single_types = %i[family single no_preference]
    @living_space_types = %i[rooms_in_home self_contained_property]
    @mobility_impairments_types = %i[yes no]
    @accommodation_length_types = %i[less_than_3_months less_than_6_months less_than_12_months more_than_12_months]
    @dbs_certificate_types = %i[yes no_but_willing no]
    @answer_more_questions_types = %i[yes no]
  end

  def as_json
    { sponsor_type:,
      family_or_single_type:,
      living_space_type:,
      mobility_impairments_type:,
      single_room_count:,
      double_room_count:,
      postcode:,
      accommodation_length_type:,
      dbs_certificate_type:,
      answer_more_questions_type:,
      fullname:,
      email:,
      mobile_number:,
      reference: }.compact
  end

private

  def validate_sponsor_type
    unless @sponsor_types.include?(@sponsor_type.to_sym)
      errors.add(:sponsor_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_family_or_single_type
    unless @family_or_single_types.include?(@family_or_single_type.to_sym)
      errors.add(:family_or_single_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_living_space_type
    unless @living_space_types.include?(@living_space_type.to_sym)
      errors.add(:living_space_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_mobility_impairments_type
    unless @mobility_impairments_types.include?(@mobility_impairments_type.to_sym)
      errors.add(:mobility_impairments_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_accommodation_length_type
    unless @accommodation_length_types.include?(@accommodation_length_type.to_sym)
      errors.add(:accommodation_length_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_dbs_certificate_type
    unless @dbs_certificate_types.include?(@dbs_certificate_type.to_sym)
      errors.add(:dbs_certificate_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_answer_more_questions_type
    unless @answer_more_questions_types.include?(@answer_more_questions_type.to_sym)
      errors.add(:answer_more_questions_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_fullname
    unless fullname.nil? || ((fullname.split.length >= 2) && (fullname.length >= 3))
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def validate_mobile_number
    if !@mobile_number.nil? && !((@mobile_number =~ /[0-9 -+]+$/) &&
      ((@mobile_number.scan(/\d/).join.length >= MIN_PHONE_DIGITS) && (@mobile_number.scan(/\d/).join.length <= MAX_PHONE_DIGITS)))
      errors.add(:mobile_number, I18n.t(:invalid_mobile_number, scope: :error))
    end
  end

  def serialize
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= SecureRandom.base64(99).gsub!(/[+=\/]/, "")[0, 10].downcase
  end
end
