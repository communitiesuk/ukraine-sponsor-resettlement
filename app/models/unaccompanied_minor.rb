require "securerandom"

Adult = Struct.new(:given_name, :family_name, :date_of_birth, :nationality, :id_type_and_number)

class UnaccompaniedMinor < ApplicationRecord
  include UamValidations
  include ContactDetailsValidations
  include ApplicationHelper

  self.table_name = "unaccompanied_minors"

  SCHEMA_VERSION = 1
  TASK_LABEL_COMPLETE = "Completed".freeze
  TASK_LABEL_IN_PROGRESS = "In progress".freeze
  TASK_LABEL_TO_DO = "Not started".freeze
  TASK_LABEL_UNAVAILABLE = "Cannot start yet".freeze

  attr_accessor :eligibility_types,
                :is_under_18,
                :is_living_december,
                :is_born_after_december,
                :is_unaccompanied,
                :is_consent,
                :is_committed,
                :is_permitted,
                :have_parental_consent,
                :have_parental_consent_options,
                :parental_consent,
                :uk_parental_consent_file_type,
                :uk_parental_consent_filename,
                :uk_parental_consent_saved_filename,
                :uk_parental_consent_file_size,
                :ukraine_parental_consent_file_type,
                :ukraine_parental_consent_filename,
                :ukraine_parental_consent_saved_filename,
                :ukraine_parental_consent_file_size,
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
                :sponsor_address_line_1,
                :sponsor_address_line_2,
                :sponsor_address_town,
                :sponsor_address_postcode,
                :sponsor_date_of_birth,
                :sponsor_date_of_birth_as_string,
                :certificate_reference,
                :minor_given_name,
                :minor_family_name,
                :minor_contact_type,
                :minor_email,
                :minor_phone_number,
                :different_address_types,
                :different_address,
                :other_adults_address_types,
                :other_adults_address,
                :type,
                :version,
                :ip_address,
                :user_agent,
                :started_at,
                :final_submission,
                :privacy_statement_confirm,
                :sponsor_declaration,
                :adult_number,
                :minor_contact_details,
                :adult_given_name,
                :adult_family_name,
                :adults_at_address

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  has_one_attached :parental_consent

  validates :parental_consent, antivirus: true # Add this for antivirus validation

  def formatted_address?
    if @residential_line_2.present?
      "#{@residential_line_1}, #{@residential_line_2}, #{@residential_town}, #{@residential_postcode}"
    else
      "#{@residential_line_1}, #{@residential_town}, #{@residential_postcode}"
    end
  end

  def number_of_adults?
    if @adults_at_address.length > 1
      "#{@adults_at_address.length} people"
    else
      "1 person"
    end
  end

  def number_of_sections?
    if adults_at_address.present? && adults_at_address.length.positive?
      5
    else
      4
    end
  end

  def number_of_completed_sections?
    completed_sections = 0

    # Section 1 checks
    if sponsor_details_names? == TASK_LABEL_COMPLETE && sponsor_details_contact_details? == TASK_LABEL_COMPLETE && sponsor_details_additional_details? == TASK_LABEL_COMPLETE
      completed_sections += 1
    end

    # Section 2 checks
    if sponsor_address_details? == TASK_LABEL_COMPLETE && sponsor_living_there_details? == TASK_LABEL_COMPLETE
      completed_sections += 1
    end

    completed_sections
  end

  def is_cancelled?
    is_cancelled
  end

  def is_submitted?
    transferred_at.present?
  end

  def minor_full_name?
    "#{minor_given_name} #{minor_family_name}"
  end

  def status_styles?(status)
    case status
    when TASK_LABEL_UNAVAILABLE, TASK_LABEL_TO_DO
      "govuk-tag--grey"
    when TASK_LABEL_IN_PROGRESS
      "govuk-tag--blue"
    else
      ""
    end
  end

  def sponsor_details_names?
    if has_other_names.present?
      TASK_LABEL_COMPLETE
    elsif given_name.present? || family_name.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_details_contact_details?
    if phone_number.present?
      TASK_LABEL_COMPLETE
    elsif email.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_details_additional_details?
    if nationality.present?
      TASK_LABEL_COMPLETE
    elsif no_identification_reason.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_address_details?
    if other_adults_address.present?
      TASK_LABEL_COMPLETE
    elsif residential_line_1.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_living_there_details?
    if (adults_at_address.present? && adults_at_address.length.positive?) || other_adults_address.present?
      TASK_LABEL_COMPLETE
    elsif different_address.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_child_details?
    if minor_date_of_birth.present? && minor_date_of_birth.length.positive?
      TASK_LABEL_COMPLETE
    elsif minor_given_name.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def uk_consent_form?
    if uk_parental_consent_filename.present?
      TASK_LABEL_COMPLETE
    else
      TASK_LABEL_TO_DO
    end
  end

  def ukraine_consent_form?
    if ukraine_parental_consent_filename.present?
      TASK_LABEL_COMPLETE
    else
      TASK_LABEL_TO_DO
    end
  end

  def privacy_consent?
    if privacy_statement_confirm.present?
      TASK_LABEL_COMPLETE
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_declaration?
    if sponsor_declaration.present?
      TASK_LABEL_COMPLETE
    else
      TASK_LABEL_TO_DO
    end
  end

  def after_initialize
    @final_submission = false
    @eligibility_types = %i[yes no]
    @have_parental_consent_options = %i[yes no]
    @different_address_types = %i[yes no]
    @other_adults_address_types = %i[yes no]
    self.certificate_reference ||= get_formatted_certificate_number
  end

  def as_json
    {
      created_at:,
      type:,
      version:,
      is_under_18:,
      is_living_december:,
      is_born_after_december:,
      is_unaccompanied:,
      is_consent:,
      is_committed:,
      is_permitted:,
      have_parental_consent:,
      uk_parental_consent_file_type:,
      uk_parental_consent_filename:,
      uk_parental_consent_saved_filename:,
      uk_parental_consent_file_size:,
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
      sponsor_address_line_1:,
      sponsor_address_line_2:,
      sponsor_address_town:,
      sponsor_address_postcode:,
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
      adults_at_address:,
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
