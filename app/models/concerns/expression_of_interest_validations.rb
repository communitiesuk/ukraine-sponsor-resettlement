module ExpressionOfInterestValidations
  extend ActiveSupport::Concern

  MIN_PHONE_DIGITS    = 9
  MAX_PHONE_DIGITS    = 14
  MIN_ENTRY_DIGITS    = 3
  MAX_ENTRY_DIGITS    = 128
  SPECIAL_CHARACTERS  = /[!"£$%{}<>|&@\/()=?^;]/
  POSTCODE_REGEX      = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})/

  included do
    validate :validate_family_type, if: -> { run_validation? :family_type }
    validate :validate_fullname, if: -> { run_validation? :fullname }
    validates :email, length: { maximum: 128, message: I18n.t(:invalid_email, scope: :error) }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t(:invalid_email, scope: :error) }, if: -> { run_validation? :email }
    validate :validate_phone_number, if: -> { run_validation? :phone_number }
    validate :validate_residential_line_1, if: -> { run_validation? :residential_line_1 }
    validate :validate_residential_line_2, if: -> { run_validation? :residential_line_2 }
    validate :validate_residential_town, if: -> { run_validation? :residential_town }
    validate :validate_residential_postcode, if: -> { run_validation? :residential_postcode }
    validate :validate_step_free, if: -> { run_validation? :step_free }
    validate :validate_hosting_start_date, if: -> { run_validation? :hosting_start_date }
    validates :single_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 999, message: I18n.t(:invalid_room_count, scope: :error) }, if: -> { run_validation? :single_room_count }
    validates :double_room_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 999, message: I18n.t(:invalid_room_count, scope: :error) }, if: -> { run_validation? :double_room_count }
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

  def validate_host_as_soon_as_possible
    validate_enum(@host_as_soon_as_possible_types, @host_as_soon_as_possible, :host_as_soon_as_possible)
  end

  def validate_enum(enum, value, attribute)
    unless value && enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_allow_eoi_pet
    validate_enum(@allow_eoi_pet_types, @allow_pet, :allow_pet)
  end

  def validate_fullname
    if @fullname.nil? || @fullname.strip.length < 3 || @fullname.strip.length > 128 || @fullname.split.length < 2 || @fullname.match(SPECIAL_CHARACTERS)
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def validate_phone_number
    unless phone_number_valid?(@phone_number)
      errors.add(:phone_number, I18n.t(:invalid_phone_number, scope: :error))
    end
  end

  def run_validation?(attribute)
    @final_submission || send(attribute)
  end

  def validate_hosting_start_date
    if @host_as_soon_as_possible != "true" && @hosting_start_date.present?
      start_day = (@hosting_start_date["3"] || @hosting_start_date[3] || nil)
      start_month = (@hosting_start_date["2"] || @hosting_start_date[2] || nil)
      start_year = (@hosting_start_date["1"] || @hosting_start_date[1] || nil)
      if !start_year.to_i || !start_month.to_i || !start_day.to_i
        errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
      end
      begin
        hosting_start = Date.new(start_year.to_i, start_month.to_i, start_day.to_i)
        if hosting_start < Time.zone.today || hosting_start.year > 2100
          errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
        end
      rescue Date::Error
        errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
      end
    else
      errors.add(:hosting_start_date, I18n.t(:invalid_hosting_start_date, scope: :error))
    end
  end
end
