require "securerandom"

class UnaccompaniedMinor < ApplicationRecord
  include UamValidations
  include ContactDetailsValidations

  self.table_name = "unaccompanied_minors"

  SCHEMA_VERSION = 1

  attr_accessor :have_parental_consent,
                :have_parental_consent_options,
                :parental_consent,
                :uk_parental_consent_file_type,
                :uk_parental_consent_filename,
                :uk_parental_consent_saved_filename,
                :minor_fullname,
                :minor_date_of_birth,
                :minor_date_of_birth_as_string,
                :fullname,
                :email,
                :phone_number,
                :residential_line_1,
                :residential_line_2,
                :residential_town,
                :residential_postcode,
                :sponsor_date_of_birth,
                :sponsor_date_of_birth_as_string,
                :agree_privacy_statement,
                :certificate_reference,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  has_one_attached :parental_consent

  validates :parental_consent, antivirus: true # Add this for antivirus validation

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
    @have_parental_consent_options = %i[yes no]
    self.certificate_reference ||= sprintf("CERT-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end

  def as_json
    {
      id:,
      reference:,
      created_at:,
      type:,
      version:,
      have_parental_consent:,
      uk_parental_consent_file_type:,
      uk_parental_consent_filename:,
      uk_parental_consent_saved_filename:,
      minor_fullname:,
      minor_date_of_birth:,
      minor_date_of_birth_as_string:,
      fullname:,
      email:,
      phone_number:,
      residential_line_1:,
      residential_line_2:,
      residential_town:,
      residential_postcode:,
      sponsor_date_of_birth:,
      sponsor_date_of_birth_as_string:,
      agree_privacy_statement:,
      certificate_reference:,
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
    self.reference ||= sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
