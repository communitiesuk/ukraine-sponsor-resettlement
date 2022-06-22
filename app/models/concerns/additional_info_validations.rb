module AdditionalInfoValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/
  POSTCODE_REGEX      = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  included do
    validate :validate_property_one_line_1, if: -> { run_validation? :property_one_line_1 }
    validate :validate_property_one_line_2, if: -> { run_validation? :property_one_line_2 }
    validate :validate_property_one_town, if: -> { run_validation? :property_one_town }
    validate :validate_property_one_postcode, if: -> { run_validation? :property_one_postcode }
  end

  def validate_property_one_line_1
    if @property_one_line_1.nil? || @property_one_line_1.strip.length < MIN_ENTRY_DIGITS || @property_one_line_1.strip.length > MAX_ENTRY_DIGITS
      errors.add(:property_one_line_1, I18n.t(:address_line_1, scope: :error))
    end
  end

  def validate_property_one_line_2
    if @property_one_line_2.present? && @property_one_line_2.strip.length > MAX_ENTRY_DIGITS
      errors.add(:property_one_line_2, I18n.t(:address_line_2, scope: :error))
    end
  end

  def validate_property_one_town
    if @property_one_town.nil? || @property_one_town.strip.length < MIN_ENTRY_DIGITS || @property_one_town.strip.length > MAX_ENTRY_DIGITS
      errors.add(:property_one_town, I18n.t(:address_town, scope: :error))
    end
  end

  def validate_property_one_postcode
    if @property_one_postcode.nil? || @property_one_postcode.strip.length < MIN_ENTRY_DIGITS || @property_one_postcode.strip.length > MAX_ENTRY_DIGITS || !@property_one_postcode.match(POSTCODE_REGEX)
      errors.add(:property_one_postcode, I18n.t(:address_postcode, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
