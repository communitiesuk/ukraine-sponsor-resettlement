class UnaccompaniedMinorTransferAdapter
  REQUIRED_KEYS = %i[
    certificate_reference
    created_at
    different_address
    email
    family_name
    given_name
    has_other_names
    has_other_nationalities
    have_parental_consent
    identification_number
    identification_type
    ip_address
    is_committed
    is_consent
    is_living_december
    is_permitted
    is_unaccompanied
    is_under_18
    minor_contact_type
    minor_date_of_birth
    minor_email
    minor_family_name
    minor_given_name
    minor_phone_number
    nationality
    other_adults_address
    phone_number
    privacy_statement_confirm
    reference
    residential_line_1
    residential_postcode
    residential_town
    sponsor_date_of_birth
    sponsor_declaration
    started_at
    type
    uk_parental_consent_filename
    uk_parental_consent_file_size
    uk_parental_consent_file_type
    ukraine_parental_consent_filename
    ukraine_parental_consent_file_size
    ukraine_parental_consent_file_type
    user_agent
    version
  ].freeze

  OPTIONAL_KEYS = %i[
    other_names
    no_identification_reason
  ].freeze

  def self.to_json(uam_hash)
    all_keys = REQUIRED_KEYS + OPTIONAL_KEYS
    Rails.logger.debug JSON.pretty_generate(uam_hash)
    Rails.logger.debug "***************************************************"
    Rails.logger.debug JSON.pretty_generate(uam_hash.slice(*all_keys))

    JSON.generate(uam_hash.slice(*all_keys))
  end
end
