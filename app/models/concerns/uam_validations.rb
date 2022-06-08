module UamValidations
  extend ActiveSupport::Concern

  included do
    # validate :validate_parental_consent, if: -> { run_validation? :parental_consent }
    validate :validate_full_name, if: -> { run_validation? :fullname }
  end

  # def validate_parental_consent
  #   errors.add(:parental_consent, I18n.t(:no_file_chosen, scope: :error))
  # end
  #
  def validate_full_name
    if @fullname.nil? || @fullname.strip.length < MIN_ENTRY_DIGITS || @fullname.strip.length > MAX_ENTRY_DIGITS || @fullname.split.length < 2 || @fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end
end
