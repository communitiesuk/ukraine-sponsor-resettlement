module ContactDetailsValidations
  extend ActiveSupport::Concern

  MIN_PHONE_DIGITS    = 9
  MAX_PHONE_DIGITS    = 14
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/

  included do
    validate :validate_fullname, if: -> { run_validation? :fullname }
    validates :email, length: { maximum: 128, message: I18n.t(:invalid_email, scope: :error) }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t(:invalid_email, scope: :error) }, if: -> { run_validation? :email }
    validate :validate_phone_number, if: -> { run_validation? :phone_number }
  end

private

  def validate_fullname
    if @fullname.nil? || @fullname.strip.length < 3 || @fullname.strip.length > 128 || @fullname.split.length < 2 || @fullname.match(SPECIAL_CHARACTERS)
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def validate_phone_number
    if @phone_number.nil? || @phone_number.scan(/\d/).join.length < MIN_PHONE_DIGITS || @phone_number.scan(/\d/).join.length > MAX_PHONE_DIGITS || !@phone_number.match(/[0-9 -+]+$/)
      errors.add(:phone_number, I18n.t(:invalid_phone_number, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
