require "securerandom"

class UnaccompaniedMinor < ApplicationRecord
  include UamValidations

  self.table_name = "unaccompanied_minors"

  SCHEMA_VERSION = 1

  attr_accessor :parental_consent,
                :fullname,
                :email,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

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
      parental_consent_filename:,
      fullname:,
      email:,
      ip_address:,
      user_agent:,
      started_at:,
    }.compact
  end

private

  def serialize
    self.type = "unaccompanied_minor"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("ANON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
