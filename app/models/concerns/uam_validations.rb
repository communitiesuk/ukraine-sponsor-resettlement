module UamValidations
  extend ActiveSupport::Concern

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/

  included do
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
    validate :validate_different_sponsor_address, if: -> { run_validation? :different_address }
    validate :validate_other_adults_address, if: -> { run_validation? :other_adults_address }
    validate :validate_residential_line_1, if: -> { run_validation? :sponsor_address_line_1 }
    validate :validate_residential_line_2, if: -> { run_validation? :sponsor_address_line_2 }
    validate :validate_residential_town, if: -> { run_validation? :sponsor_address_town }
    validate :validate_residential_postcode, if: -> { run_validation? :sponsor_address_postcode }
  end

  def validate_minor_date_of_birth
    if @minor_date_of_birth[3].blank? || @minor_date_of_birth[2].blank? || @minor_date_of_birth[1].blank?
      errors.add(:minor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))

    elsif Time.zone.parse(@minor_date_of_birth.map { |_, v| v }.join("-").to_s) >= Time.zone.now.to_date
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

  def validate_different_sponsor_address
    validate_enum(@different_address_types, @different_address, :different_address)
  end

  def validate_other_adults_address
    validate_enum(@other_adults_address_types, @other_adults_address, :other_adults_address)
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

  def validate_sponsor_address_line_1
    if @sponsor_address_line_1.nil? || @sponsor_address_line_1.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_line_1.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_line_1, I18n.t(:address_line_1, scope: :error))
    end
  end

  def validate_sponsor_address_line_2
    if @sponsor_address_line_2.present? && @sponsor_address_line_2.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_line_2, I18n.t(:address_line_2, scope: :error))
    end
  end

  def validate_sponsor_address_town
    if @sponsor_address_town.nil? || @sponsor_address_town.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_town.strip.length > MAX_ENTRY_DIGITS
      errors.add(:residential_town, I18n.t(:address_town, scope: :error))
    end
  end

  def validate_sponsor_address_postcode
    if @sponsor_address_postcode.nil? || @sponsor_address_postcode.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_postcode.strip.length > MAX_ENTRY_DIGITS || !@sponsor_address_postcode.match(POSTCODE_REGEX)
      errors.add(:residential_postcode, I18n.t(:address_postcode, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
