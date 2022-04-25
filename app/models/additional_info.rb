class AdditionalInfo < ApplicationRecord
  include ContactDetailsValidations

  self.table_name = "additional_info"

  SCHEMA_VERSION = 1

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
                :residential_pet_types,
                :residential_pet,
                :user_research_types,
                :user_research,
                :property_one_line_1,
                :property_one_line_2,
                :property_one_town,
                :property_one_postcode,
                :property_one_pet_types,
                :property_one_pet,
                :more_properties_types,
                :more_properties,
                :more_properties_statement,
                :type, :version, :ip_address, :user_agent, :final_submission

  validate :validate_different_address, if: -> { run_validation? :different_address }
  validate :validate_residential_pet, if: -> { run_validation? :residential_pet }
  validate :validate_user_research, if: -> { run_validation? :user_research }
  validate :validate_property_one_pet, if: -> { run_validation? :property_one_pet }
  validate :validate_more_properties, if: -> { run_validation? :more_properties }

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
    @different_address_types = %i[yes no]
    @residential_pet_types = %i[yes no]
    @user_research_types = %i[yes no]
    @property_one_pet_types = %i[yes no]
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
      residential_pet:,
      property_one_line_1:,
      property_one_line_2:,
      property_one_town:,
      property_one_postcode:,
      property_one_pet:,
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

  def validate_residential_pet
    validate_enum(@residential_pet_types, @residential_pet, :residential_pet)
  end

  def validate_property_one_pet
    validate_enum(@property_one_pet_types, @property_one_pet, :property_one_pet)
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

  def serialize
    self.type = "additional_info"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end
end
