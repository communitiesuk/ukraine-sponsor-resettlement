module CommonValidations
  extend ActiveSupport::Concern

  def validate_number_adults
    @is_residential_property    = different_address.present? && different_address.casecmp("NO").zero?
    @is_number_adults_integer   = is_integer?(@number_adults)
    @is_number_children_integer = is_integer?(number_children)

    if @is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_one, scope: :error))
    elsif @is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero?
      errors.add(:number_adults, I18n.t(:number_adults_residential, scope: :error))
    elsif !@is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_zero, scope: :error))
    elsif !@is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero? && @is_number_children_integer && number_children.to_i.positive?
      errors.add(:number_adults, I18n.t(:child_without_adult, scope: :error))
    end
  end

  def is_integer?(value)
    true if Integer(value, exception: false)
  end

  def validate_different_address
    validate_enum(@different_address_types, @different_address, :different_address)
  end

  def validate_allow_pet_pet
    validate_enum(@allow_pet_types, @allow_pet, :allow_pet)
  end

  def validate_more_properties
    validate_enum(@more_properties_types, @more_properties, :more_properties)
  end

  def validate_user_research
    validate_enum(@user_research_types, @user_research, :user_research)
  end

  def validate_enum(enum, value, attribute)
    unless value && enum.include?(value.to_sym)
      errors.add(attribute, I18n.t(:choose_option, scope: :error))
    end
  end

  def name_valid?(value)
    min_name_length = 1
    max_name_length = 128
    validator = /^[-'a-zA-Z\s]{#{min_name_length},#{max_name_length}}$/

    value.present? && !!(value =~ validator)
  end

  def email_address_valid?(value)
    min_length = 2
    max_length = 128
    validator = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{#{min_length},#{max_length}})\z/i

    value.present? && !!(value =~ validator)
  end

  def phone_number_valid?(value)
    value.present? && value.scan(/\d/).join.length > 10 && value.scan(/\d/).join.length < 14 && value.match(/[0-9 -+]+$/)
  end

  def uk_mobile_number?(value)
    valid_uk_number = /(^\+447[0-9]{9}$)|(^07[0-9]{9}$)|(^447[0-9]{9}$)/
    blanks_removed = value.gsub(/\s+/, "")
    value.present? && blanks_removed.match?(valid_uk_number)
  end
end
