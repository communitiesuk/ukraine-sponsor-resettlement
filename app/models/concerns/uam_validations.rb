module UamValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128

  included do
    validate :validate_parental_consent, if: -> { run_validation? :parental_consent }
    validate :validate_full_name, if: -> { run_validation? :fullname }
  end

  def validate_parental_consent
    Rails.logger.debug @original_filename

    if @parental_consent.nil? && @original_filename.nil?
      errors.add(:parental_consent, I18n.t(:no_file_chosen, scope: :error))
    else
      @parental_consent_filename = @original_filename
    end
  end

  def validate_full_name
    if @fullname.nil? || @fullname.strip.length < MIN_ENTRY_DIGITS || @fullname.strip.length > MAX_ENTRY_DIGITS || @fullname.split.length < 2 || @fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
