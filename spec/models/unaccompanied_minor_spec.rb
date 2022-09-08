require "rails_helper"

RSpec.describe UnaccompaniedMinor, type: :model do
  let(:given_name_error) { "You must enter a valid given name" }
  let(:family_name_error) { "You must enter a valid family name" }
  let(:email_address_error) { "You must enter a valid email address" }
  let(:phone_numbers_error) { "You must enter a valid phone number" }
  let(:empty_address_error) { "You must enter an address" }
  let(:empty_town_city_error) { "You must enter a town or city" }
  let(:postcode_error) { "You must enter a valid UK postcode" }
  let(:no_choice_error) { "You must select an option to continue" }

  describe "dynamic task list requirements" do
    it "calculates the number of sections to be completed" do
      app = described_class.new
      expect(app.number_of_sections?).to be(4)
      app.adults_at_address = { "123" => Adult.new }
      expect(app.number_of_sections?).to be(5)
    end

    it "calculates the number of completed sections" do
      app = described_class.new
      expect(app.number_of_completed_sections?).to be(0)
      # Who are you? section is complete
      app.has_other_names = "true"
      app.phone_number = "07777 123 456"
      app.nationality = "nationality"
      expect(app.number_of_completed_sections?).to be(1)
      app.residential_line_1 = "Address line 1"
      app.residential_town = "Town"
      app.residential_postcode = "XX1 2XX"
      app.different_address = "yes"
      # Where will the child live? section is complete
      app.other_adults_address = "no"
      app.adults_at_address = { "123" => Adult.new }
      expect(app.number_of_completed_sections?).to be(2)
      # Tell use about the child section is complete
      app.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }
      app.uk_parental_consent_filename = "UK consent file name"
      app.ukraine_parental_consent_filename = "Ukraine consent file name"
      expect(app.number_of_completed_sections?).to be(3)
      # Send your application section is complete
      app.privacy_statement_confirm = "true"
      app.sponsor_declaration = "true"
      expect(app.number_of_completed_sections?).to be(4)
    end
  end

  describe "contact detail validations" do
    it "sponsor full name is valid" do
      app = described_class.new
      app.given_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:given_name]).to include(given_name_error)
      expect(app.errors[:given_name].count).to be(1)
      app.family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:family_name]).to include(family_name_error)
      expect(app.errors[:family_name].count).to be(1)
      app.given_name = ""
      app.family_name = "Smith"
      expect(app.valid?).to be(false)
      expect(app.errors[:given_name]).to include(given_name_error)
      expect(app.errors[:given_name].count).to be(1)
      app.given_name = "John"
      app.family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:family_name]).to include(family_name_error)
      expect(app.errors[:family_name].count).to be(1)
      app.given_name = "John"
      app.family_name = "Smith"
      expect(app.valid?).to be(true)
    end

    it "sponsor email is valid" do
      app = described_class.new
      app.email = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include(email_address_error)
      expect(app.errors[:email].count).to be(1)
      app.email = "John.Smith@"
      expect(app.valid?).to be(false)
      expect(app.errors[:email]).to include(email_address_error)
      expect(app.errors[:email].count).to be(1)
      app.email = "John.Smith@test.com"
      expect(app.valid?).to be(true)
    end

    it "sponsor phone is valid" do
      app = described_class.new
      app.phone_number = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include(phone_numbers_error)
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "07777 888 99"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include(phone_numbers_error)
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "123456789012345"
      expect(app.valid?).to be(false)
      expect(app.errors[:phone_number]).to include(phone_numbers_error)
      expect(app.errors[:phone_number].count).to be(1)
      app.phone_number = "07777 888 999"
      expect(app.valid?).to be(true)
    end

    it "sponsor address line 1 is valid" do
      app = described_class.new
      app.residential_line_1 = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include(empty_address_error)
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = "A"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include(empty_address_error)
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_1]).to include(empty_address_error)
      expect(app.errors[:residential_line_1].count).to be(1)
      app.residential_line_1 = "Address line 1"
      expect(app.valid?).to be(true)
    end

    it "sponsor address line 2 is valid" do
      app = described_class.new
      app.residential_line_2 = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_line_2]).to include("You must enter less than 128 characters")
      expect(app.errors[:residential_line_2].count).to be(1)
      app.residential_line_2 = ""
      expect(app.valid?).to be(true)
      app.residential_line_2 = "A"
      expect(app.valid?).to be(true)
      app.residential_line_2 = "Address line 2"
      expect(app.valid?).to be(true)
    end

    it "sponsor address town is valid" do
      app = described_class.new
      app.residential_town = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include(empty_town_city_error)
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = "A"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include(empty_town_city_error)
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_town]).to include(empty_town_city_error)
      expect(app.errors[:residential_town].count).to be(1)
      app.residential_town = "Address town"
      expect(app.valid?).to be(true)
    end

    it "address postcode is valid" do
      app = described_class.new
      app.residential_postcode = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include(postcode_error)
      app.residential_postcode = " "
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include(postcode_error)
      app.residential_postcode = ("X" * 129).to_s
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include(postcode_error)
      app.residential_postcode = "XX1 XX"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include(postcode_error)
      app.residential_postcode = "XX 1XX"
      expect(app.valid?).to be(false)
      expect(app.errors[:residential_postcode]).to include(postcode_error)
      app.residential_postcode = "XX1 1XX"
      expect(app.valid?).to be(true)
    end

    it "other adults at address is valid when page is skipped" do
      app = described_class.new
      app.other_adults_address = ""
      app.different_address = "yes"
      expect(app.valid?).to be(false)
      expect(app.errors[:other_adults_address]).to include(no_choice_error)
      app.different_address = "yes"
      expect(app.valid?).to be(false)
      expect(app.errors[:other_adults_address]).to include(no_choice_error)
      app.different_address = "no"
      expect(app.valid?).to be(true)
    end
  end

  describe "parental consent questions" do
    it "ensure content type" do
      app = described_class.new
      app.uk_parental_consent_file_type = "invalid"
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("You can only upload pdf, jpeg or png files")
      app.uk_parental_consent_file_type = "application/pdf"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/png"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/jpg"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "image/jpeg"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "APPLICATION/PDF"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/PNG"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/JPG"
      expect(app.valid?).to be(true)
      app.uk_parental_consent_file_type = "IMAGE/JPEG"
      expect(app.valid?).to be(true)
    end

    it "ensure the file is 20MB or smaller" do
      app = described_class.new
      app.uk_parental_consent_file_size = 1024*1024*21
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("Your file must be smaller than 20MB")
      app.uk_parental_consent_file_size = 1024*1024*20
      expect(app.valid?).to be(true)
      app.ukraine_parental_consent_file_size = 1024*1024*21
      expect(app.valid?).to be(false)
      expect(app.errors[:ukraine_parental_consent]).to include("Your file must be smaller than 20MB")
      app.ukraine_parental_consent_file_size = 1024*1024*20
      expect(app.valid?).to be(true)
    end

    it "ensure file name is provided" do
      app = described_class.new
      app.uk_parental_consent_filename = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:uk_parental_consent]).to include("You must choose a file")
      app.uk_parental_consent_filename = "name-of-file-uploaded"
      expect(app.valid?).to be(true)
    end

    it "validates that the have parental consent forms attribute is selected" do
      app = described_class.new
      app.have_parental_consent = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:have_parental_consent]).to include(no_choice_error)
      app.have_parental_consent = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "age validations" do
    it "sponsor is older than 18" do
      app = described_class.new
      app.sponsor_date_of_birth = {
        3 => 1,
        2 => 1,
        1 => Time.zone.now.year - 5,
      }
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_date_of_birth]).to include(I18n.t(:too_young_date_of_birth, scope: :error))
      expect(app.errors[:sponsor_date_of_birth].count).to be(1)
      app.sponsor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 20,
      }
      expect(app.valid?).to be(true)
    end
  end

  describe "accept privacy terms" do
    it "validates that the have privacy terms is selected" do
      app = described_class.new
      app.privacy_statement_confirm = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:privacy_statement_confirm]).to include("You must read and agree to the privacy statement")
      app.privacy_statement_confirm = "false"
      expect(app.valid?).to be(false)
      expect(app.errors[:privacy_statement_confirm]).to include("You must read and agree to the privacy statement")
      app.privacy_statement_confirm = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "accept sponsor declaration" do
    it "validates that the have sponsor checkbox is selected" do
      app = described_class.new
      app.sponsor_declaration = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_declaration]).to include("You must check the box to continue")
      app.sponsor_declaration = "false"
      expect(app.valid?).to be(false)
      expect(app.errors[:sponsor_declaration]).to include("You must check the box to continue")
      app.sponsor_declaration = "true"
      expect(app.valid?).to be(true)
    end
  end

  describe "task list status styles" do
    it "return style for status name" do
      app = described_class.new
      expect(app.status_styles?("Cannot start yet")).to eq("govuk-tag--grey")
      expect(app.status_styles?("Not started")).to eq("govuk-tag--grey")
      expect(app.status_styles?("In progress")).to eq("govuk-tag--blue")
      expect(app.status_styles?("Completed")).to eq("")
    end
  end

  describe "task list sponsor details" do
    it "return status for names" do
      app = described_class.new
      expect(app.sponsor_details_names?).to eq("Not started")
      app.given_name = "Bob"
      app.family_name = "Smith"
      expect(app.sponsor_details_names?).to eq("In progress")
      app.has_other_names = "true"
      expect(app.sponsor_details_names?).to eq("Completed")
    end

    it "return status for contact details" do
      app = described_class.new
      expect(app.sponsor_details_contact_details?).to eq("Not started")
      app.email = "test@test.com"
      expect(app.sponsor_details_contact_details?).to eq("In progress")
      app.phone_number = "07777 123 456"
      expect(app.sponsor_details_contact_details?).to eq("Completed")
    end

    it "return status for additional details" do
      app = described_class.new
      expect(app.sponsor_details_additional_details?).to eq("Not started")
      app.no_identification_reason = "reason"
      expect(app.sponsor_details_additional_details?).to eq("In progress")
      app.nationality = "nationality"
      expect(app.sponsor_details_additional_details?).to eq("Completed")
    end

    it "return status for main address" do
      app = described_class.new
      expect(app.sponsor_address_details?).to eq("Not started")
      app.residential_line_1 = "Address line 1"
      expect(app.sponsor_address_details?).to eq("In progress")
      app.residential_town = "Town"
      app.residential_postcode = "XX1 2XX"
      app.different_address = "yes"
      expect(app.sponsor_address_details?).to eq("Completed")
    end

    it "return status for different address" do
      app = described_class.new
      expect(app.sponsor_address_details?).to eq("Not started")
      app.residential_line_1 = "Address line 1"
      app.residential_town = "Town"
      app.residential_postcode = "XX1 2XX"
      app.different_address = "no"
      app.sponsor_address_line_1 = "Address line 1"
      expect(app.sponsor_address_details?).to eq("In progress")
      app.sponsor_address_town = "Town"
      app.sponsor_address_postcode = "XX1 2XX"
      expect(app.sponsor_address_details?).to eq("Completed")
    end

    it "return status for who will be living at address" do
      app = described_class.new
      expect(app.sponsor_living_there_details?).to eq("Not started")
      app.residential_line_1 = "Address line 1"
      app.residential_town = "Town"
      app.residential_postcode = "XX1 2XX"
      app.different_address = "yes"
      app.sponsor_address_line_1 = "Address line 1"
      app.sponsor_address_town = "Town"
      app.sponsor_address_postcode = "XX1 2XX"
      expect(app.sponsor_living_there_details?).to eq("Not started")
      app.adults_at_address = {}
      app.other_adults_address = "no"
      expect(app.sponsor_living_there_details?).to eq("Completed")
      app.other_adults_address = "yes"
      app.adults_at_address = { "123" => Adult.new }
      expect(app.sponsor_living_there_details?).to eq("Completed")
    end

    it "return status for child personal details" do
      app = described_class.new
      expect(app.sponsor_child_details?).to eq("Not started")
      app.minor_given_name = "First name"
      expect(app.sponsor_child_details?).to eq("In progress")
      app.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }
      expect(app.sponsor_child_details?).to eq("Completed")
    end

    it "return status for resident personal details" do
      app = described_class.new
      # app.adults_at_address = {}
      # app.adults_at_address.store("123", Adult.new("Bob", "Jones"))
      expect(app.sponsor_resident_details?("", "", "", "", "")).to eq("Not started")
      expect(app.sponsor_resident_details?("dob", "", "", "", "")).to eq("In progress")
      expect(app.sponsor_resident_details?("first", "family", "dob", "nationality", "id_and_type")).to eq("Completed")
    end

    it "return status for UK consent form" do
      app = described_class.new
      expect(app.uk_consent_form?).to eq("Not started")
      app.uk_parental_consent_filename = "UK consent file name"
      expect(app.uk_consent_form?).to eq("Completed")
    end

    it "return status for Ukraine consent form" do
      app = described_class.new
      expect(app.ukraine_consent_form?).to eq("Not started")
      app.ukraine_parental_consent_filename = "Ukraine consent file name"
      expect(app.ukraine_consent_form?).to eq("Completed")
    end

    it "return status for privacy consent form" do
      app = described_class.new
      expect(app.privacy_consent?).to eq("Not started")
      app.privacy_statement_confirm = "true"
      expect(app.privacy_consent?).to eq("Completed")
    end

    it "return status for sponsor declaration form" do
      app = described_class.new
      expect(app.sponsor_declaration?).to eq("Not started")
      app.sponsor_declaration = "true"
      expect(app.sponsor_declaration?).to eq("Completed")
    end

    # it "return status for each dynamic over 16 task item", :focus do
    #   app = described_class.new
    #   app.adults_at_address = {}
    #   app.adults_at_address.store("abc", Adult.new("John", "Smith"))
    #   expect(app.task_item?("abc")).to eq("Not started")
    #   app.adults_at_address.store("abc", Adult.new(date_of_birth => "20-02-2002"))
    #   expect(app.task_item?("abc")).to eq("In progress")
    #   app.adults_at_address.store("abc", Adult.new(id_type_and_number: "id - number"))
    #   expect(app.task_item?("abc")).to eq("Completed")
    # end
  end

  describe "child flow validation" do
    it "child's given and family name" do
      app = described_class.new
      app.minor_given_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_given_name]).to include(given_name_error)
      expect(app.errors[:minor_given_name].count).to be(1)
      app.minor_family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_family_name]).to include(family_name_error)
      expect(app.errors[:minor_family_name].count).to be(1)
      app.minor_given_name = ""
      app.minor_family_name = "Smith"
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_given_name]).to include(given_name_error)
      expect(app.errors[:minor_given_name].count).to be(1)
      app.minor_given_name = "John"
      app.minor_family_name = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:minor_family_name]).to include(family_name_error)
      expect(app.errors[:minor_family_name].count).to be(1)
      app.minor_given_name = "John"
      app.minor_family_name = "Smith"
      expect(app.valid?).to be(true)
    end
  end

  describe "address formatting" do
    it "show address when address line 2 blank" do
      app = described_class.new
      app.residential_line_1 = "Address line 1"
      app.residential_town = "Town"
      app.residential_postcode = "AA1 1AA"

      expect(app.formatted_address?).to eq("Address line 1, Town, AA1 1AA")
    end

    it "show address when address line 2 not blank" do
      app = described_class.new
      app.residential_line_1 = "Address line 1"
      app.residential_line_2 = "Address line 2"
      app.residential_town = "Town"
      app.residential_postcode = "AA1 1AA"

      expect(app.formatted_address?).to eq("Address line 1, Address line 2, Town, AA1 1AA")
    end
  end

  describe "eligibility validation" do
    it "is born after december" do
      app = described_class.new
      app.is_living_december = "yes"
      app.is_born_after_december = ""
      expect(app.valid?).to be(true)
      app.is_living_december = "no"
      app.is_born_after_december = ""
      expect(app.valid?).to be(false)
      expect(app.errors[:is_born_after_december]).to include(no_choice_error)
      expect(app.errors[:is_born_after_december].count).to be(1)
      app.is_living_december = "no"
      app.is_born_after_december = "yes"
      expect(app.valid?).to be(true)
    end
  end

  describe "application is ready for submission" do
    def populate_min_valid_section_one(uam)
      uam.has_other_names = "false"
      uam.phone_number = "01234567890"
      uam.nationality = "CH"
    end

    def populate_min_valid_section_two(uam)
      uam.residential_line_1 = "Address line 1"
      uam.residential_town = "Town"
      uam.residential_postcode = "XX1 2XX"
      uam.different_address = "yes"
      uam.other_adults_address = "true"
    end

    def populate_min_valid_section_three(uam)
      uam.minor_date_of_birth = {
        3 => 1,
        2 => 6,
        1 => Time.zone.now.year - 5,
      }
      uam.uk_parental_consent_filename = "uk_parental_consent.pdf"
      uam.ukraine_parental_consent_filename = "ukraine_parental_consent.pdf"
    end

    def populate_min_valid_section_four(uam)
      uam.privacy_statement_confirm = "true"
      uam.sponsor_declaration = "true"
    end

    def populate_min_other_adults_section(uam)
      uam.adults_at_address = {}
      uam.adults_at_address.store("123", Adult.new("First name", "Last name", "1990-09-19", "AUS - Australia", "P - 123456789"))
    end

    def populate_incomplete_other_adults_section(uam)
      uam.adults_at_address = {}
      uam.adults_at_address.store("123", Adult.new("First name", "Last name", "1990-09-19", "AUS - Australia"))
    end

    it "can not be submitted when all but section 1 is complete" do
      app = described_class.new

      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "can not be submitted when all but section 2 is complete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "can not be submitted when all but section 3 is complete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_four(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "can not be submitted when section 4 is incomplete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "can be submitted when sections 1,2,3 and 4 are complete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)

      expect(app.is_application_ready_to_be_sent?).to be(true)
    end

    it "can be submitted when other adults section is complete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)
      populate_min_other_adults_section(app)

      expect(app.is_application_ready_to_be_sent?).to be(true)
    end

    it "can not be submitted when other adults section is incomplete" do
      app = described_class.new

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)
      populate_min_other_adults_section(app)
      populate_incomplete_other_adults_section(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "can not be submitted when other adults section is complete but one other section is incomplete" do
      app = described_class.new

      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)
      populate_min_other_adults_section(app)

      expect(app.is_application_ready_to_be_sent?).to be(false)
    end

    it "as_json outputs the application reference" do
      app = described_class.new
      app.save!(validate: false)

      populate_min_valid_section_one(app)
      populate_min_valid_section_two(app)
      populate_min_valid_section_three(app)
      populate_min_valid_section_four(app)

      expect(app.as_json[:reference]).to start_with("SPON-")
    end
  end
end
