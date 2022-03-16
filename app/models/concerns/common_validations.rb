module CommonValidations
  extend ActiveSupport::Concern

  MIN_PHONE_DIGITS = 9
  MAX_PHONE_DIGITS = 14

  included do
    validate :validate_family_type, if: -> { run_validation? :family_type }
    validate :validate_fullname, if: -> { run_validation? :fullname }
    validates :email, length: { maximum: 128, message: I18n.t(:invalid_email, scope: :error) }, format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t(:invalid_email, scope: :error) }, if: -> { run_validation? :email }
    validate :validate_phone_number, if: -> { run_validation? :phone_number }
    validate :validate_step_free, if: -> { run_validation? :step_free }
    validates :single_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t(:invalid_number, scope: :error) }, if: -> { run_validation? :single_room_count }
    validates :double_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: I18n.t(:invalid_number, scope: :error) }, if: -> { run_validation? :double_room_count }
    validates :postcode, length: { minimum: 2, maximum: 100, message: I18n.t(:invalid_postcode, scope: :error) }, if: -> { run_validation? :postcode }
    validates :agree_future_contact, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, if: -> { run_validation? :agree_future_contact }
    validates :agree_privacy_statement, acceptance: { accept: "true", message: I18n.t(:must_be_accepted, scope: :error) }, if: -> { run_validation? :agree_privacy_statement }
  end

private

  def validate_family_type
    validate_enum(@family_types, @family_type, :family_type)
  end

  def validate_step_free
    validate_enum(@step_free_types, @step_free, :step_free)
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

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
