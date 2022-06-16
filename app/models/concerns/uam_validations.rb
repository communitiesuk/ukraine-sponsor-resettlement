module UamValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128

  included do
    validate :validate_parent_consent_file_type, if: -> { run_validation? :parental_consent_file_type }
    validate :validate_parent_consent_filename, if: -> { run_validation? :parental_consent_filename }
    validate :validate_full_name, if: -> { run_validation? :fullname }
  end

  def validate_parent_consent_file_type
    if @parental_consent_file_type.nil? || @parental_consent_file_type != "application/pdf"
      errors.add(:parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_parent_consent_filename
    if @parental_consent_filename.nil? || @parental_consent_filename.strip.empty?
      errors.add(:parental_consent, I18n.t(:no_file_chosen, scope: :error))
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
