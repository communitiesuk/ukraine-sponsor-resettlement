class AdditionalInfo < ApplicationRecord
  include ContactDetailsValidations

  self.table_name = "additional_info"

  SCHEMA_VERSION = 2

  attr_accessor :reference, :started_at, :residential_line_1, :residential_line_2, :residential_town, :residential_postcode, :fullname, :email, :phone_number, :proof_of_ids, :proof_of_id, :type, :version, :ip_address, :user_agent, :final_submission

  validate :validate_proof_of_id, if: -> { run_validation? :proof_of_id }

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
    @proof_of_ids = %i[passport drivers_licence other]
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
        proof_of_id:,
        ip_address:,
        user_agent:,
        started_at:,
    }.compact
  end

  private

  def validate_proof_of_id
    validate_enum(@proof_of_ids, @proof_of_id, :proof_of_id)
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
