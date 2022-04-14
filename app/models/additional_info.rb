class AdditionalInfo < ApplicationRecord
  include ContactDetailsValidations

  self.table_name = "additional_info"

  SCHEMA_VERSION = 2

  attr_accessor :reference, :started_at, :email, :fullname, :type, :version, :ip_address, :user_agent, :final_submission

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
  end

  def as_json
    {
        id:,
        reference:,
        created_at:,
        type:,
        version:,
        email:,
        fullname:,
        ip_address:,
        user_agent:,
        started_at:,
    }.compact
  end

  private

  def serialize
    self.type = "additional_info"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end
end
