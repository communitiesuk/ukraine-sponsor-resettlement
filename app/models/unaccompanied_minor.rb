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
                :uk_parental_consent_file_upload_rid,
                :uk_parental_consent_file_uploaded_timestamp,
                :ukraine_parental_consent_file_type,
                :ukraine_parental_consent_filename,
                :ukraine_parental_consent_saved_filename,
                :ukraine_parental_consent_file_size,
                :ukraine_parental_consent_file_upload_rid,
                :ukraine_parental_consent_file_uploaded_timestamp,
                :minor_date_of_birth,
                :minor_date_of_birth_as_string,
                :given_name,
                :family_name,
                :has_other_names,
                :other_given_name,
                :other_family_name,
                :other_names,
                :email,
                :email_confirm,
                :phone_number,
                :identification_type,
                :identification_number,
                :passport_identification_number,
                :id_identification_number,
                :refugee_identification_number,
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
                :minor_email_confirm,
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
                :adults_at_address,
                :adult_date_of_birth,
                :adult_nationality,
                :adult_identification_type,
                :adult_passport_identification_number,
                :adult_id_identification_number,
                :adult_refugee_identification_number

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  after_find do
    assign_attributes(answers)
  end

  has_one_attached :parental_consent

  validates :parental_consent, antivirus: true # Add this for antivirus validation

  def formatted_address?
    [@residential_line_1, @residential_line_2, @residential_town, @residential_postcode].reject(&:blank?).join(", ")
  end

  def saved_nationalities_as_list
    res = []
    if @nationality.present?
      res << [@nationality]
    end
    if @other_nationalities.present?
      res |= @other_nationalities
    end
    res
  end

  def number_of_adults?
    if @adults_at_address.length > 1
      "#{@adults_at_address.length} people"
    else
      "1 person"
    end
  end

  def number_of_sections?
    if is_adults_at_address_populated?
      5
    else
      4
    end
  end

  def is_section_one_complete?
    sponsor_details_names? == TASK_LABEL_COMPLETE && \
      sponsor_details_contact_details? == TASK_LABEL_COMPLETE && \
      sponsor_details_additional_details? == TASK_LABEL_COMPLETE
  end

  def is_section_two_complete?
    sponsor_address_details? == TASK_LABEL_COMPLETE && \
      sponsor_living_there_details? == TASK_LABEL_COMPLETE
  end

  def is_section_three_complete?
    sponsor_child_details? == TASK_LABEL_COMPLETE && \
      uk_consent_form? == TASK_LABEL_COMPLETE && \
      ukraine_consent_form? == TASK_LABEL_COMPLETE
  end

  def is_section_four_enabled?
    is_section_one_complete? && \
      is_section_two_complete? && \
      is_section_three_complete?
  end

  def is_section_four_complete?
    privacy_consent? == TASK_LABEL_COMPLETE && \
      sponsor_declaration? == TASK_LABEL_COMPLETE
  end

  def is_section_adults_at_address_complete?
    statuses = []

    adults_at_address.each do |_key, val|
      statuses << (sponsor_resident_details?(val["given_name"], val["family_name"], val["date_of_birth"], val["nationality"], val["id_type_and_number"]) == TASK_LABEL_COMPLETE)
    end

    !statuses.include?(false)
  end

  def is_application_ready_to_be_sent?
    all_sections_completed = is_section_one_complete? && \
      is_section_two_complete? && \
      is_section_three_complete? && \
      is_section_four_complete?

    if all_sections_completed && adults_at_address.present?
      all_sections_completed = is_section_adults_at_address_complete?
    end

    all_sections_completed
  end

  def number_of_completed_sections?
    completed_sections = 0

    # Who are you?
    if is_section_one_complete?
      completed_sections += 1
    end

    # Where will the child live?
    if is_section_two_complete?
      completed_sections += 1
    end

    # Tell us about the child
    if is_section_three_complete?
      completed_sections += 1
    end

    # Send your application
    if is_section_four_complete?
      completed_sections += 1
    end

    # Dynamic section
    if adults_at_address.present? && is_section_adults_at_address_complete?
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

  def sponsor_full_name?
    "#{given_name} #{family_name}"
  end

  def minor_full_name?
    "#{minor_given_name} #{minor_family_name}"
  end

  def is_sponsor_address_details_populated?
    formatted_address?.present? && formatted_address?.length.positive?
  end

  def is_adults_at_address_populated?
    adults_at_address.present? && adults_at_address.length.positive?
  end

  def heading_number?(default)
    if is_adults_at_address_populated?
      "#{default + 1}."
    else
      "#{default}."
    end
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
    # are they both complete?
    if is_main_address_complete? && (different_address == "yes" || (different_address == "no" && is_secondary_address_complete?))
      TASK_LABEL_COMPLETE
    # are they both empty?
    elsif is_main_address_empty? && is_secondary_address_empty?
      TASK_LABEL_TO_DO
    # is one of the two incomplete?
    else
      TASK_LABEL_IN_PROGRESS
    end
  end

  def sponsor_living_there_details?
    if (adults_at_address.present? && adults_at_address.length.positive?) || other_adults_address.present?
      TASK_LABEL_COMPLETE
    elsif different_address.present? && other_adults_address.present? && other_adults_address == "yes"
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_child_details?
    if minor_date_of_birth.present?
      TASK_LABEL_COMPLETE
    elsif minor_given_name.present?
      TASK_LABEL_IN_PROGRESS
    else
      TASK_LABEL_TO_DO
    end
  end

  def sponsor_resident_details?(given_name = "", family_name = "", date_of_birth = "", nationality = "", id = "")
    required_vals = [given_name, family_name, date_of_birth, nationality, id]
    if required_vals.all? { |item| item.to_s.length.positive? }
      TASK_LABEL_COMPLETE
    elsif required_vals.all? { |item| item.to_s.length.zero? }
      TASK_LABEL_TO_DO
    else
      TASK_LABEL_IN_PROGRESS
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
      reference:,
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
      uk_parental_consent_file_upload_rid:,
      uk_parental_consent_file_uploaded_timestamp:,
      ukraine_parental_consent_file_type:,
      ukraine_parental_consent_filename:,
      ukraine_parental_consent_saved_filename:,
      ukraine_parental_consent_file_size:,
      ukraine_parental_consent_file_upload_rid:,
      ukraine_parental_consent_file_uploaded_timestamp:,
      minor_date_of_birth:,
      minor_date_of_birth_as_string:,
      given_name:,
      family_name:,
      email:,
      email_confirm:,
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
      different_address:,
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
      minor_email_confirm:,
      minor_phone_number:,
      ip_address:,
      user_agent:,
      started_at:,
      sponsor_declaration:,
      adult_number:,
      minor_contact_details:,
      other_adults_address:,
      adults_at_address:,
    }.compact
  end

private

  def is_main_address_empty?
    # function that checks if the mandatory elements for the main address are filled in
    [@residential_line_1, @residential_town, @residential_postcode].all? { |item| item.to_s.length.zero? }
  end

  def is_secondary_address_empty?
    # function that checks if the mandatory elements for the main address are filled in
    [@sponsor_address_line_1, @sponsor_address_town, @sponsor_address_postcode].all? { |item| item.to_s.length.zero? }
  end

  def is_main_address_complete?
    # function that checks if the mandatory elements for the main address are filled in
    [@residential_line_1, @residential_town, @residential_postcode].all? { |item| item.to_s.length.positive? }
  end

  def is_secondary_address_complete?
    # function that checks if the mandatory elements for the main address are filled in
    [@sponsor_address_line_1, @sponsor_address_town, @sponsor_address_postcode].all? { |item| item.to_s.length.positive? }
  end

  def serialize
    self.type = "unaccompanied_minor"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end

  def generate_reference
    self.reference ||= sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
  end
end
