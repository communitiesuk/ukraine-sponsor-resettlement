class AdditionalInfo < ApplicationRecord
  include ContactDetailsValidations

  self.table_name = "additional_info"

  SCHEMA_VERSION = 2

  attr_accessor :reference, :started_at, :residential_line_1, :residential_line_2, :residential_town, :residential_postcode, :fullname, :email, :phone_number, :residential_host_types, :residential_host, :residential_pet_types, :residential_pet, :type, :version, :ip_address, :user_agent, :final_submission

  validate :validate_residential_host, if: -> { run_validation? :residential_host }
  validate :validate_residential_pet, if: -> { run_validation? :residential_pet }

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
    @residential_host_types = %i[yes no]
    @residential_pet_types = %i[yes no]
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
        residential_host:,
        residential_pet:,
        ip_address:,
        user_agent:,
        started_at:,
    }.compact
  end

  private

  def validate_residential_host
    validate_enum(@residential_host_types, @residential_host, :residential_host)
  end

  def validate_residential_pet
    validate_enum(@residential_pet_types, @residential_pet, :residential_pet)
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
