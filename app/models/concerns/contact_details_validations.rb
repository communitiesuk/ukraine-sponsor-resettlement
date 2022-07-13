module ContactDetailsValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/
  POSTCODE_REGEX      = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  included do
    validate :validate_residential_line_1, if: -> { run_validation? :residential_line_1 }
    validate :validate_residential_line_2, if: -> { run_validation? :residential_line_2 }
    validate :validate_residential_town, if: -> { run_validation? :residential_town }
    validate :validate_residential_postcode, if: -> { run_validation? :residential_postcode }
    validate :validate_full_name, if: -> { run_validation? :fullname }
    validates :email, length: { maximum: 128, message: I18n.t(:invalid_email, scope: :error) }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t(:invalid_email, scope: :error) }, if: -> { run_validation? :email }
    validate :validate_phone_number, if: -> { run_validation? :phone_number }
  end

private

  def validate_residential_line_1
    if @residential_line_1.nil? || @residential_line_1.strip.length < MIN_ENTRY_DIGITS || @residential_line_1.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_line_1, I18n.t(:address_line_1, scope: :error))
    end
  end

  def validate_residential_line_2
    if @residential_line_2.present? && @residential_line_2.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_line_2, I18n.t(:address_line_2, scope: :error))
    end
  end

  def validate_residential_town
    if @residential_town.nil? || @residential_town.strip.length < MIN_ENTRY_DIGITS || @residential_town.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_town, I18n.t(:address_town, scope: :error))
    end
  end

  def validate_residential_postcode
    if @residential_postcode.nil? || @residential_postcode.strip.length < MIN_ENTRY_DIGITS || @residential_postcode.strip.length > MAX_ENTRY_DIGITS || !@residential_postcode.match(POSTCODE_REGEX)
      errors.add(:residential_postcode, I18n.t(:address_postcode, scope: :error))
    end
  end

  def validate_full_name
    if @fullname.nil? || @fullname.strip.length < MIN_ENTRY_DIGITS || @fullname.strip.length > MAX_ENTRY_DIGITS || @fullname.split.length < 2 || @fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:minor_fullname, I18n.t(:invalid_minor_fullname, scope: :error))
    end
  end

  def validate_phone_number
    if @phone_number.nil? || @phone_number.scan(/\d/).join.length < 11 || @phone_number.scan(/\d/).join.length > 14 || !@phone_number.match(/[0-9 -+]+$/)
      errors.add(:phone_number, I18n.t(:invalid_phone_number, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
