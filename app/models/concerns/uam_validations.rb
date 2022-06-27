module UamValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128

  included do
    validate :validate_minor_full_name, if: -> { run_validation? :minor_fullname }
    validate :validate_minor_date_of_birth, if: -> { run_validation? :minor_date_of_birth }
    validate :validate_sponsor_date_of_birth, if: -> { run_validation? :sponsor_date_of_birth }
    validate :validate_have_parental_consent, if: -> { run_validation? :have_parental_consent }
    validate :validate_parent_consent_file_type, if: -> { run_validation? :uk_parental_consent_file_type }
    validate :validate_parent_consent_filename, if: -> { run_validation? :uk_parental_consent_filename }
    validate :validate_full_name, if: -> { run_validation? :fullname }
    validate :validate_agree_privacy_statement, if: -> { run_validation? :agree_privacy_statement }
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

  def validate_parent_consent_file_type
    if @uk_parental_consent_file_type.nil? || @uk_parental_consent_file_type != "application/pdf"
      errors.add(:uk_parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_parent_consent_filename
    if @uk_parental_consent_filename.nil? || @uk_parental_consent_filename.strip.empty?
      errors.add(:uk_parental_consent, I18n.t(:no_file_chosen, scope: :error))
    end
  end

  def validate_full_name
    if @fullname.nil? || @fullname.strip.length < MIN_ENTRY_DIGITS || @fullname.strip.length > MAX_ENTRY_DIGITS || @fullname.split.length < 2 || @fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:minor_fullname, I18n.t(:invalid_minor_fullname, scope: :error))
    end
  end

  def validate_agree_privacy_statement
    if @agree_privacy_statement.nil? || @agree_privacy_statement.strip.length.zero?
      errors.add(:agree_privacy_statement, I18n.t(:choose_option, scope: :error))
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

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
