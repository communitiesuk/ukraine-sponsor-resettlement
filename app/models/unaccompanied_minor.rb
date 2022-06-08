require "securerandom"

class UnaccompaniedMinor < ApplicationRecord
  self.table_name = "unaccompanied_minors"

  SCHEMA_VERSION = 1

  attr_accessor :parental_consent,
                :parental_consent_filename,
                :fullname,
                :email,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission

  validate :validate_parental_consent, if: -> { run_validation? :parental_consent }
  validate :validate_full_name, if: -> { run_validation? :fullname }

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

  def validate_parental_consent
    errors.add(:parental_consent, I18n.t(:no_file_chosen, scope: :error))
  end

  def validate_full_name
    if @fullname.nil? || @fullname.strip.length < MIN_ENTRY_DIGITS || @fullname.strip.length > MAX_ENTRY_DIGITS || @fullname.split.length < 2 || @fullname.match(/[!"£$%{}<>|&@\/()=?^;]/)
      errors.add(:fullname, I18n.t(:invalid_fullname, scope: :error))
    end
  end

  def serialize
    self.type = "unaccompanied_minor"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("ANON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
