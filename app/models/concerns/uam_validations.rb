module UamValidations
  extend ActiveSupport::Concern

  include CommonValidations

  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  ALLOWED_FILE_TYPES = ["application/pdf", "image/png", "image/jpeg", "image/jpg"].freeze
  POSTCODE_REGEX = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  included do
    validate :validate_adult_family_name, if: -> { run_validation? :adult_family_name }
    validate :validate_adult_given_name, if: -> { run_validation? :adult_given_name }
    validate :validate_different_sponsor_address, if: -> { run_validation? :different_address }
    validate :validate_family_name, if: -> { run_validation? :family_name }
    validate :validate_given_name, if: -> { run_validation? :given_name }
    validate :validate_have_parental_consent, if: -> { run_validation? :have_parental_consent }
    validate :validate_is_born_after_december, if: -> { run_validation? :is_born_after_december }
    validate :validate_is_committed, if: -> { run_validation? :is_committed }
    validate :validate_is_consent, if: -> { run_validation? :is_consent }
    validate :validate_is_living_december, if: -> { run_validation? :is_living_december }
    validate :validate_is_permitted, if: -> { run_validation? :is_permitted }
    validate :validate_is_unaccompanied, if: -> { run_validation? :is_unaccompanied }
    validate :validate_is_under_18, if: -> { run_validation? :is_under_18 }
    validate :validate_minor_date_of_birth, if: -> { run_validation? :minor_date_of_birth }
    validate :validate_minor_email, if: -> { run_validation? :minor_email }
    validate :validate_minor_family_name, if: -> { run_validation? :minor_family_name }
    validate :validate_minor_given_name, if: -> { run_validation? :minor_given_name }
    validate :validate_minor_phone_number, if: -> { run_validation? :minor_phone_number }
    validate :validate_other_adults_address, if: -> { run_validation? :other_adults_address }
    validate :validate_privacy_statement_confirm, if: -> { run_validation? :privacy_statement_confirm }
    validate :validate_residential_line_1, if: -> { run_validation? :sponsor_address_line_1 }
    validate :validate_residential_line_2, if: -> { run_validation? :sponsor_address_line_2 }
    validate :validate_residential_postcode, if: -> { run_validation? :sponsor_address_postcode }
    validate :validate_residential_town, if: -> { run_validation? :sponsor_address_town }
    validate :validate_sponsor_address_line_1, if: -> { run_validation? :sponsor_address_line_1 }
    validate :validate_sponsor_address_line_2, if: -> { run_validation? :sponsor_address_line_2 }
    validate :validate_sponsor_address_postcode, if: -> { run_validation? :sponsor_address_postcode }
    validate :validate_sponsor_address_town, if: -> { run_validation? :sponsor_address_town }
    validate :validate_sponsor_date_of_birth, if: -> { run_validation? :sponsor_date_of_birth }
    validate :validate_sponsor_declaration, if: -> { run_validation? :sponsor_declaration }
    validate :validate_uk_parent_consent_filename, if: -> { run_validation? :uk_parental_consent_filename }
    validate :validate_uk_parent_consent_file_size, if: -> { run_validation? :uk_parental_consent_file_size }
    validate :validate_uk_parent_consent_file_type, if: -> { run_validation? :uk_parental_consent_file_type }
    validate :validate_ukraine_parent_consent_filename, if: -> { run_validation? :ukraine_parental_consent_filename }
    validate :validate_ukraine_parent_consent_file_size, if: -> { run_validation? :ukraine_parental_consent_file_size }
    validate :validate_ukraine_parent_consent_file_type, if: -> { run_validation? :ukraine_parental_consent_file_type }
  end

  def validate_sponsor_date_of_birth
    dob_day = (@sponsor_date_of_birth["3"] || @sponsor_date_of_birth[3] || nil)
    dob_month = (@sponsor_date_of_birth["2"] || @sponsor_date_of_birth[2] || nil)
    dob_year = (@sponsor_date_of_birth["1"] || @sponsor_date_of_birth[1] || nil)
    if !dob_year.to_i || !dob_month.to_i || !dob_day.to_i
      errors.add(:required_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
    begin
      sponsor_dob = Date.new(dob_year.to_i, dob_month.to_i, dob_day.to_i)
      if (sponsor_dob.year < 1900 || sponsor_dob.year > 2100) || \
          (sponsor_dob.month < 1 || sponsor_dob.month > 12) || \
          (sponsor_dob.day < 1 || sponsor_dob.day > 31)
        errors.add(:sponsor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
      elsif 18.years.ago.to_date < sponsor_dob
        errors.add(:sponsor_date_of_birth, I18n.t(:too_young_date_of_birth, scope: :error))
      end
    rescue Date::Error
      errors.add(:sponsor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
  end

  def validate_minor_date_of_birth
    dob_day = (@minor_date_of_birth["3"] || @minor_date_of_birth[3] || nil)
    dob_month = (@minor_date_of_birth["2"] || @minor_date_of_birth[2] || nil)
    dob_year = (@minor_date_of_birth["1"] || @minor_date_of_birth[1] || nil)
    if !dob_year.to_i || !dob_month.to_i || !dob_day.to_i
      errors.add(:required_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
    begin
      minor_dob = Date.new(dob_year.to_i, dob_month.to_i, dob_day.to_i)
      if (minor_dob.year < 1900 || minor_dob.year > 2100) || \
          (minor_dob.month < 1 || minor_dob.month > 12) || \
          (minor_dob.day < 1 || minor_dob.day > 31)
        errors.add(:minor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
      elsif minor_dob <= 18.years.ago.to_date
        errors.add(:minor_date_of_birth, I18n.t(:too_old_date_of_birth, scope: :error))
      end
    rescue Date::Error
      errors.add(:minor_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
  end

  def validate_adult_date_of_birth
    dob_day = (@adult_date_of_birth["3"] || @adult_date_of_birth[3] || nil)
    dob_month = (@adult_date_of_birth["2"] || @adult_date_of_birth[2] || nil)
    dob_year = (@adult_date_of_birth["1"] || @adult_date_of_birth[1] || nil)
    if !dob_year.to_i || !dob_month.to_i || !dob_day.to_i
      errors.add(:adult_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
    begin
      adult_date_of_birth = Date.new(dob_year.to_i, dob_month.to_i, dob_day.to_i)
      if (adult_date_of_birth.year < 1900 || adult_date_of_birth.year > 2100) || \
          (adult_date_of_birth.month < 1 || adult_date_of_birth.month > 12) || \
          (adult_date_of_birth.day < 1 || adult_date_of_birth.day > 31)
        errors.add(:adult_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
      elsif adult_date_of_birth > 16.years.ago.to_date
        errors.add(:adult_date_of_birth, I18n.t(:not_over_16_years_old, scope: :error))
      end
    rescue Date::Error
      errors.add(:adult_date_of_birth, I18n.t(:invalid_date_of_birth, scope: :error))
    end
  end

  def validate_is_under_18
    validate_enum(@eligibility_types, @is_under_18, :is_under_18)
  end

  def validate_is_living_december
    validate_enum(@eligibility_types, @is_living_december, :is_living_december)
  end

  def validate_is_born_after_december
    validate_enum(@eligibility_types, @is_born_after_december, :is_born_after_december) if @is_living_december.present? && @is_living_december.casecmp("no").zero?
  end

  def validate_is_unaccompanied
    validate_enum(@eligibility_types, @is_unaccompanied, :is_unaccompanied)
  end

  def validate_is_consent
    validate_enum(@eligibility_types, @is_consent, :is_consent)
  end

  def validate_is_committed
    validate_enum(@eligibility_types, @is_committed, :is_committed)
  end

  def validate_is_permitted
    validate_enum(@eligibility_types, @is_permitted, :is_permitted)
  end

  def validate_have_parental_consent
    validate_enum(@have_parental_consent_options, @have_parental_consent, :have_parental_consent)
  end

  def validate_uk_parent_consent_file_type
    if @uk_parental_consent_file_type.nil? || !ALLOWED_FILE_TYPES.include?(@uk_parental_consent_file_type.downcase)
      errors.add(:uk_parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_uk_parent_consent_filename
    if @uk_parental_consent_filename.nil? || @uk_parental_consent_filename.strip.empty?
      errors.add(:uk_parental_consent, I18n.t(:no_file_chosen, scope: :error))
    end
  end

  def validate_uk_parent_consent_file_size
    if @uk_parental_consent_file_size > 1024 * 1024 * 20
      errors.add(:uk_parental_consent, I18n.t(:file_too_large, scope: :error))
    end
  end

  def validate_ukraine_parent_consent_file_type
    if @ukraine_parental_consent_file_type.nil? || !ALLOWED_FILE_TYPES.include?(@ukraine_parental_consent_file_type.downcase)
      errors.add(:ukraine_parental_consent, I18n.t(:invalid_file_type_chosen, scope: :error))
    end
  end

  def validate_ukraine_parent_consent_filename
    if @ukraine_parental_consent_filename.nil? || @ukraine_parental_consent_filename.strip.empty?
      errors.add(:ukraine_parental_consent, I18n.t(:no_file_chosen, scope: :error))
    end
  end

  def validate_ukraine_parent_consent_file_size
    if @ukraine_parental_consent_file_size > 1024 * 1024 * 20
      errors.add(:ukraine_parental_consent, I18n.t(:file_too_large, scope: :error))
    end
  end

  def validate_given_name
    unless name_valid?(@given_name)
      errors.add(:given_name, I18n.t(:invalid_given_name, scope: :error))
    end
  end

  def validate_family_name
    unless name_valid?(@family_name)
      errors.add(:family_name, I18n.t(:invalid_family_name, scope: :error))
    end
  end

  def validate_privacy_statement_confirm
    if @privacy_statement_confirm.nil? || @privacy_statement_confirm.strip.length.zero? || @privacy_statement_confirm == "false"
      errors.add(:privacy_statement_confirm, I18n.t(:privacy_statement, scope: :error))
    end
  end

  def validate_minor_given_name
    unless name_valid?(@minor_given_name)
      errors.add(:minor_given_name, I18n.t(:invalid_given_name, scope: :error))
    end
  end

  def validate_minor_family_name
    unless name_valid?(@minor_family_name)
      errors.add(:minor_family_name, I18n.t(:invalid_family_name, scope: :error))
    end
  end

  def validate_different_sponsor_address
    validate_enum(@different_address_types, @different_address, :different_address)
  end

  def validate_other_adults_address
    validate_enum(@other_adults_address_types, @other_adults_address, :other_adults_address) if @different_address.present? && @different_address.casecmp("yes").zero?
  end

  def validate_adult_given_name
    if !@final_submission && !name_valid?(@adult_given_name)
      errors.add(:adult_given_name, I18n.t(:invalid_given_name, scope: :error))
    end
  end

  def validate_adult_family_name
    if !@final_submission && !name_valid?(@adult_family_name)
      errors.add(:adult_family_name, I18n.t(:invalid_family_name, scope: :error))
    end
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
    if @different_address == "no" && (@sponsor_address_line_1.nil? || @sponsor_address_line_1.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_line_1.strip.length > MAX_ENTRY_DIGITS)
      errors.add(:sponsor_address_line_1, I18n.t(:address_line_1, scope: :error))
    end
  end

  def validate_sponsor_address_line_2
    if @different_address == "no" && (@sponsor_address_line_2.present? && @sponsor_address_line_2.strip.length > MAX_ENTRY_DIGITS)
      errors.add(:sponsor_address_line_2, I18n.t(:address_line_2, scope: :error))
    end
  end

  def validate_sponsor_address_town
    if @different_address == "no" && (@sponsor_address_town.nil? || @sponsor_address_town.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_town.strip.length > MAX_ENTRY_DIGITS)
      errors.add(:sponsor_address_town, I18n.t(:address_town, scope: :error))
    end
  end

  def validate_sponsor_address_postcode
    if @different_address == "no" && (@sponsor_address_postcode.nil? || @sponsor_address_postcode.strip.length < MIN_ENTRY_DIGITS || @sponsor_address_postcode.strip.length > MAX_ENTRY_DIGITS || !@sponsor_address_postcode.match(POSTCODE_REGEX))
      errors.add(:sponsor_address_postcode, I18n.t(:address_postcode, scope: :error))
    end
  end

  def validate_minor_email
    if !@minor_contact_type.nil? && @minor_contact_type.include?("email") && !email_address_valid?(@minor_email)
      errors.add(:minor_email, I18n.t(:invalid_email, scope: :error))
    end
  end

  def validate_minor_phone_number
    if !@minor_contact_type.nil? && @minor_contact_type.include?("telephone") && !phone_number_valid?(@minor_phone_number)
      errors.add(:minor_phone_number, I18n.t(:invalid_phone_number, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end
end
