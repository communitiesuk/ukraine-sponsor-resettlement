module UamValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/

  included do
    # validate :validate_minor_full_name, if: -> { run_validation? :minor_fullname }
    validate :validate_minor_date_of_birth, if: -> { run_validation? :minor_date_of_birth }
    validate :validate_sponsor_date_of_birth, if: -> { run_validation? :sponsor_date_of_birth }
    validate :validate_have_parental_consent, if: -> { run_validation? :have_parental_consent }
    validate :validate_uk_parent_consent_file_type, if: -> { run_validation? :uk_parental_consent_file_type }
    validate :validate_uk_parent_consent_filename, if: -> { run_validation? :uk_parental_consent_filename }
    validate :validate_ukraine_parent_consent_file_type, if: -> { run_validation? :ukraine_parental_consent_file_type }
    validate :validate_ukraine_parent_consent_filename, if: -> { run_validation? :ukraine_parental_consent_filename }
    validate :validate_given_name, if: -> { run_validation? :given_name }
    validate :validate_family_name, if: -> { run_validation? :family_name }
    validate :validate_privacy_statement_confirm, if: -> { run_validation? :privacy_statement_confirm }
    validate :validate_sponsor_declaration, if: -> { run_validation? :sponsor_declaration }
    validate :validate_minor_given_name, if: -> { run_validation? :minor_given_name }
    validate :validate_minor_family_name, if: -> { run_validation? :minor_family_name }
  end

  def validate_minor_full_name
    if @minor_fullname.nil? || @minor_fullname.strip.length < MIN_ENTRY_DIGITS || @minor_fullname.strip.length > MAX_ENTRY_DIGITS || @minor_fullname.split.length < 2 || @minor_fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:minor_fullname, I18n.t(:invalid_minor_fullname, scope: :error))
    end
  end

  def validate_minor_date_of_birth
    if @minor_date_of_birth.blank? || Time.zone.parse(@minor_date_of_birth.map { |_, v| v }.join("-").to_s) >= Time.zone.now.to_date
      errors.add(:minor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    elsif Time.zone.parse(@minor_date_of_birth.map { |_, v| v }.join("-").to_s) < 18.years.ago.to_date
      errors.add(:minor_date_of_birth, I18n.t(:too_old_date_of_birth, scope: :error))
    end
  end

  def validate_sponsor_date_of_birth
    if @sponsor_date_of_birth.blank? || Time.zone.parse(@sponsor_date_of_birth.map { |_, v| v }.join("-").to_s) >= Time.zone.now.to_date
      errors.add(:sponsor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    elsif Time.zone.parse(@sponsor_date_of_birth.map { |_, v| v }.join("-").to_s) > 18.years.ago.to_date
      errors.add(:sponsor_date_of_birth, I18n.t(:too_young_date_of_birth, scope: :error))
    end
  end

  def validate_uk_parent_consent_file_type
    if @uk_parental_consent_file_type.nil? || @uk_parental_consent_file_type != "application/pdf"
      errors.add(:uk_parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_uk_parent_consent_filename
    if @uk_parental_consent_filename.nil? || @uk_parental_consent_filename.strip.empty?
      errors.add(:uk_parental_consent, I18n.t(:no_file_chosen, scope: :error))
    end
  end

  def validate_ukraine_parent_consent_file_type
    if @ukraine_parental_consent_file_type.nil? || @ukraine_parental_consent_file_type != "application/pdf"
      errors.add(:ukraine_parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_ukraine_parent_consent_filename
    if @ukraine_parental_consent_filename.nil? || @ukraine_parental_consent_filename.strip.empty?
      errors.add(:ukraine_parental_consent, I18n.t(:no_file_chosen, scope: :error))
    end
  end

  def validate_given_name
    if @given_name.nil? || @given_name.strip.length < MIN_ENTRY_DIGITS || @given_name.strip.length > MAX_ENTRY_DIGITS || @given_name.match(SPECIAL_CHARACTERS)
      errors.add(:given_name, I18n.t(:invalid_given_name, scope: :error))
    end
  end

  def validate_family_name
    if @family_name.nil? || @family_name.strip.length < MIN_ENTRY_DIGITS || @family_name.strip.length > MAX_ENTRY_DIGITS || @family_name.match(SPECIAL_CHARACTERS)
      errors.add(:family_name, I18n.t(:invalid_family_name, scope: :error))
    end
  end

  def validate_privacy_statement_confirm
    if @privacy_statement_confirm.nil? || @privacy_statement_confirm.strip.length.zero? || @privacy_statement_confirm == "false"
      errors.add(:privacy_statement_confirm, I18n.t(:privacy_statement, scope: :error))
    end
  end

  def validate_minor_given_name
    if @minor_given_name.nil? || @minor_given_name.strip.length < MIN_ENTRY_DIGITS || @minor_given_name.strip.length > MAX_ENTRY_DIGITS || @minor_given_name.match(SPECIAL_CHARACTERS)
      errors.add(:minor_given_name, I18n.t(:invalid_given_name, scope: :error))
    end
  end

  def validate_minor_family_name
    if @minor_family_name.nil? || @minor_family_name.strip.length < MIN_ENTRY_DIGITS || @minor_family_name.strip.length > MAX_ENTRY_DIGITS || @minor_family_name.match(SPECIAL_CHARACTERS)
      errors.add(:minor_family_name, I18n.t(:invalid_family_name, scope: :error))
    end
  end

  def validate_have_parental_consent
    validate_enum(@have_parental_consent_options, @have_parental_consent, :have_parental_consent)
  end

  def validate_enum(enum, value, attribute)
    unless value && enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_sponsor_declaration
    if @sponsor_declaration.nil? || @sponsor_declaration.strip.length.zero? || @sponsor_declaration == "false"
      errors.add(:sponsor_declaration, I18n.t(:invalid_eligibility, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
