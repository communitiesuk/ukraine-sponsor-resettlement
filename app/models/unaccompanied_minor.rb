require "securerandom"

class UnaccompaniedMinor < ApplicationRecord
  include UamValidations
  include ContactDetailsValidations
  include ApplicationHelper

  self.table_name = "unaccompanied_minors"

  SCHEMA_VERSION = 1

  attr_accessor :is_eligible,
                :have_parental_consent,
                :have_parental_consent_options,
                :parental_consent,
                :uk_parental_consent_file_type,
                :uk_parental_consent_filename,
                :uk_parental_consent_saved_filename,
                :ukraine_parental_consent_file_type,
                :ukraine_parental_consent_filename,
                :ukraine_parental_consent_saved_filename,
                :minor_date_of_birth,
                :minor_date_of_birth_as_string,
                :given_name,
                :family_name,
                :has_other_names,
                :other_given_name,
                :other_family_name,
                :other_names,
                :email,
                :phone_number,
                :identification_type,
                :identification_number,
                :no_identification_reason,
                :nationality,
                :has_other_nationalities,
                :other_nationality,
                :other_nationalities,
                :residential_line_1,
                :residential_line_2,
                :residential_town,
                :residential_postcode,
                :sponsor_date_of_birth,
                :sponsor_date_of_birth_as_string,
                :certificate_reference,
                :minor_given_name,
                :minor_family_name,
                :minor_contact_type,
                :minor_email,
                :minor_phone_number,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission,
                :privacy_statement_confirm,
                :sponsor_declaration,
                :adult_number,
                :minor_contact_details

  after_initialize :after_initialize
  before_save :serialize
  # before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  has_one_attached :parental_consent

  validates :parental_consent, antivirus: true # Add this for antivirus validation

  def is_cancelled?
    is_cancelled
  end

  def minor_full_name?
    "#{minor_given_name} #{minor_family_name}"
  end

  def status_styles?(status)
    case status
    when "Cannot start yet", "Not started"
      "govuk-tag--grey"
    when "In progress"
      "govuk-tag--blue"
    else
      ""
    end
  end

  def sponsor_details_names?
    if @has_other_names.present?
      "Completed"
    elsif given_name.present? || family_name.present?
      "In progress"
    else
      "Not started"
    end
  end

  def sponsor_details_contact_details?
    if phone_number.present?
      "Completed"
    elsif email.present?
      "In progress"
    else
      "Not started"
    end
  end

  def sponsor_details_additional_details?
    if nationality.present?
      "Completed"
    elsif no_identification_reason.present?
      "In progress"
    else
      "Not started"
    end
  end

  def after_initialize
    @final_submission = false
    @have_parental_consent_options = %i[yes no]
    self.certificate_reference ||= get_formatted_certificate_number
  end

  def as_json
    {
      created_at:,
      type:,
      version:,
      is_eligible:,
      have_parental_consent:,
      uk_parental_consent_file_type:,
      uk_parental_consent_filename:,
      uk_parental_consent_saved_filename:,
      ukraine_parental_consent_file_type:,
      ukraine_parental_consent_filename:,
      ukraine_parental_consent_saved_filename:,
      minor_date_of_birth:,
      minor_date_of_birth_as_string:,
      given_name:,
      family_name:,
      email:,
      has_other_names:,
      other_given_name:,
      other_family_name:,
      other_names:,
      phone_number:,
      identification_type:,
      identification_number:,
      no_identification_reason:,
      nationality:,
      has_other_nationalities:,
      other_nationality:,
      other_nationalities:,
      residential_line_1:,
      residential_line_2:,
      residential_town:,
      residential_postcode:,
      sponsor_date_of_birth:,
      sponsor_date_of_birth_as_string:,
      privacy_statement_confirm:,
      certificate_reference:,
      minor_given_name:,
      minor_family_name:,
      minor_contact_type:,
      minor_email:,
      minor_phone_number:,
      ip_address:,
      user_agent:,
      started_at:,
      sponsor_declaration:,
      adult_number:,
      minor_contact_details:,
    }.compact
  end

private

  def serialize
    self.type = "unaccompanied_minor"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  # def generate_reference
  #   self.reference ||= sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  # end
end
