class AdditionalInfo < ApplicationRecord
  include ContactDetailsValidations

  self.table_name = "additional_info"

  SCHEMA_VERSION = 2

  attr_accessor :reference,
                :started_at,
                :residential_line_1,
                :residential_line_2,
                :residential_town,
                :residential_postcode,
                :fullname,
                :email,
                :phone_number,
                :different_address_types,
                :different_address,
                :user_research_types,
                :user_research,
                :property_one_line_1,
                :property_one_line_2,
                :property_one_town,
                :property_one_postcode,
                :number_adults,
                :number_children,
                :allow_pet_types,
                :allow_pet,
                :more_properties_types,
                :more_properties,
                :more_properties_statement,
                :type, :version, :ip_address, :user_agent, :final_submission

  validate :validate_different_address, if: -> { run_validation? :different_address }
  validate :validate_more_properties, if: -> { run_validation? :more_properties }
  validate :validate_number_adults, if: -> { run_validation? :number_adults }
  validates :number_children, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9, message: I18n.t(:number_children, scope: :error) }, if: -> { run_validation? :number_children }
  validate :validate_allow_pet_pet, if: -> { run_validation? :allow_pet }
  validate :validate_user_research, if: -> { run_validation? :user_research }

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
    @different_address_types = %i[yes no]
    @user_research_types = %i[yes no]
    @allow_pet_types = %i[yes no]
    @more_properties_types = %i[yes no]
  end

  def as_json
    {
      id:,
      reference:,
      created_at:,
      type:,
      version:,
      residential_line_1:,
      residential_line_2:,
      residential_town:,
      residential_postcode:,
      fullname:,
      email:,
      phone_number:,
      different_address:,
      property_one_line_1:,
      property_one_line_2:,
      property_one_town:,
      property_one_postcode:,
      number_adults:,
      number_children:,
      allow_pet:,
      more_properties:,
      more_properties_statement:,
      user_research:,
      ip_address:,
      user_agent:,
      started_at:,
    }.compact
  end

private

  def validate_different_address
    validate_enum(@different_address_types, @different_address, :different_address)
  end

  def validate_number_adults
    @is_residential_property = different_address.casecmp("NO").zero?

    if @is_residential_property && is_integer?(@number_adults) && @number_adults.to_i.zero?
      errors.add(:number_adults, I18n.t(:number_adults_residential, scope: :error))
    elsif @is_residential_property && is_integer?(@number_adults) && @number_adults.to_i > 9
      errors.add(:number_adults, I18n.t(:number_adults_one, scope: :error))
    elsif @is_residential_property && !is_integer?(@number_adults)
      errors.add(:number_adults, I18n.t(:number_adults_one, scope: :error))
    elsif !@is_residential_property && !is_integer?(@number_adults)
      errors.add(:number_adults, I18n.t(:number_adults_zero, scope: :error))
    elsif !@is_residential_property && is_integer?(@number_adults) && @number_adults.to_i > 9
      errors.add(:number_adults, I18n.t(:number_adults_zero, scope: :error))
    elsif !@is_residential_property && is_integer?(@number_adults) && @number_adults.to_i.zero? && is_integer?(number_children) && number_children.to_i.positive?
      errors.add(:number_adults, I18n.t(:child_without_adult, scope: :error))
    end
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

  def is_integer?(value)
    true if Integer(value, exception: false)
  end

  def serialize
    self.type = "additional_info"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end
end
