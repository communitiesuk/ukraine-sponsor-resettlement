require('cypress-xpath');
const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
const alfa = require('../../pages/UAM/uam_eligibility')
const secrets = require('../../../fixtures/uam_appdata.json')
   
export const uam_tasklist_page = () => {
    cy.visit('/task-list')
    alfa.uam_eligibility_tasklist
    cy.get(elements.your_details_heading).contains('Your details').should('be.visible')
    cy.xpath(elements.childs_accormadation_heading).contains('Child’s accommodation').should('be.visible')
    cy.xpath(elements.childs_details_heading).contains("Child's details").should('be.visible')
    cy.xpath(elements.send_your_application_heading).contains("Send your application").should('be.visible').wait(Cypress.env('waitTime'))
}
//SPONSOR NAME
export const your_details_name_step_10 = () => {
    cy.get(elements.name).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your name').should('be.visible')
    cy.get(elements.summary_text).contains("I'm not sure how to enter my name").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.save_and_return_label).contains('Save and return later').should('be.visible')
    cy.get(elements.given_names_label).contains("Given names").should('be.visible')
    cy.get(elements.family_name_label).contains("Family name").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.given_names_textbox).type(secrets.given_names)
    cy.get(elements.family_name_textbox).type(secrets.family_name)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_othername_step_11 = () => {
    cy.get(elements.page_heading).contains('Have you ever been known by another name?').should('be.visible')
    cy.get(elements.known_by_another_name_hinttext).contains('For example, if you changed your name after marriage.').should('be.visible')
    cy.get(elements.select_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_othername_step_12 = () => {
    cy.get(elements.page_heading).contains('Add your other name').should('be.visible')
    cy.get(elements.summary_text).contains("I'm not sure how to enter my nam").should('be.visible')
    cy.get(elements.other_given_names_label).contains("Given names").should('be.visible')
    cy.get(elements.other_family_name_label).contains("Family name").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.other_given_names_textbox).type(secrets.known_by_given_names)
    cy.get(elements.other_family_name_textbox).type(secrets.known_by_family_name)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_othername_step_13 = () => {
    cy.get(elements.page_heading).contains('You have added 1 other name').should('be.visible')
    cy.get(elements.other_added_names_label).contains('KNOWN BY OTHER NAME').should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.name_completed).should('be.visible')
}
export const your_details_contact_details_step_14 = () => {
    alfa.uam_tasklist_header()
    cy.get(elements.contact_details_link).click()
    cy.get(elements.page_heading).contains('Enter your email address').should('be.visible')
    cy.get(elements.email_ad_body).contains(bodytext.step14_bodytext).should('be.visible')
    cy.get(elements.email_ad_label).contains('Email address').should('be.visible')
    cy.get(elements.confirm_email_ad_label).contains('Confirm email address').should('be.visible')
    cy.get(elements.email_ad_textbox).type(secrets.email)
    cy.get(elements.confirm_email_ad_textbox).type(secrets.email)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_mobile_step_15 = () => {
    cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible')
    cy.get(elements.mobile_number_body).contains('Enter a UK mobile phone number that you have access to, so you can save and continue your application later.').should('be.visible')
    cy.get(elements.mobile_number_label).contains('UK mobile number').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.confirm_mobile_number_label).contains('Confirm mobile number').should('be.visible')
    cy.get(elements.mobile_number_textbox).type(secrets.mobile)
    cy.get(elements.confirm_mobile_number_textbox).type(secrets.mobile)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const additional_details_labels = () => {
    cy.get(elements.page_heading).contains('Do you have any of these identity documents?').should('be.visible')
    cy.get(elements.passport_label).contains('Passport').should('be.visible')
    cy.get(elements.ni_label).contains('National identity card').should('be.visible')
    cy.get(elements.refugee_teavel_doc_label).contains('Refugee travel document').should('be.visible')
    cy.get(elements.dont_have_any_label).contains("I don't have any of these").should('be.visible').wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_16 = () => {
    alfa.uam_tasklist_header()
    cy.get(elements.contact_details_completed).contains('Completed').should('be.visible')
    cy.get(elements.additional_details).click().wait(Cypress.env('waitTime'))
    additional_details_labels()
    cy.get(elements.passport_nm_radio_button).click()
    cy.get(elements.passport_nm_textbox).type(secrets.passport_no)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_18 = () => {
    cy.get(elements.page_heading).contains('Enter your date of birth').should('be.visible')
    cy.get(elements.day_textbox).type(secrets.day)
    cy.get(elements.month_textbox).type(secrets.month)
    cy.get(elements.year_textbox).type(secrets.year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_19 = () => {
    cy.get(elements.page_heading).contains('Enter your nationality').should('be.visible')
    cy.get(elements.nationality_label).contains('You will be able to add other nationalities on the next page.').should('be.visible').wait(500)
    cy.get(elements.nationality_dropdown).select('AFG - Afghanistan').should('have.value', 'AFG - Afghanistan').wait(Cypress.env('waitTime'))
        .select('USA - United States').should('have.value', 'USA - United States').wait(Cypress.env('waitTime'))
        .select('GBR - United Kingdom').should('have.value', 'GBR - United Kingdom')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_20 = () => {
    cy.get(elements.page_heading).contains('Have you ever held any other nationalities?').should('be.visible')
    cy.get(elements.other_nationalities_hint).contains("Select 'Yes' if you have ever held any other nationalities, even if you don't hold them any more.").should('be.visible')
    cy.get(elements.other_nationalities_yes_radio_button).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_21 = () => {
    cy.get(elements.page_heading).contains('Enter your other nationality').should('be.visible')
    cy.get(elements.other_nationality_hint).contains("Select your country of nationality").should('be.visible')
    cy.get(elements.other_nationality_dropdown).select('GBD - British Overseas Territories').should('have.value', 'GBD - British Overseas Territories').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_additional_details_step_22 = () => {
    cy.get(elements.page_heading).contains('You have added 1 other nationality').should('be.visible')
    cy.get(elements.listed_other_nationalities).contains("GBD - British Overseas Territories").should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
}
//VERIFY COMPLETED
export const verify_completed_tasks_1_of_4 = () => {
    alfa.uam_eligibility_tasklist
    cy.xpath(elements.completed_1_of_4_label).contains('You have completed 1 of 4 sections.').should('be.visible')
    cy.xpath(elements.completed_name).contains('Completed').should('be.visible')
    cy.xpath(elements.completed_details).contains('Completed').should('be.visible')
    cy.xpath(elements.completed_ad_details).contains('Completed').should('be.visible').wait(Cypress.env('waitTime'))
}
export const childs_accommodation_step_23 = () => {
    cy.visit('/task-list')
    cy.get(elements.address_link).click()
    cy.get(elements.page_heading).contains('Enter the address where the child will be living in the UK').should('be.visible')
    cy.get(elements.child_address_line1_label).contains('Address line 1').should('be.visible')
    cy.get(elements.child_address_line2_label).contains('Address line 2 (optional)').should('be.visible')
    cy.get(elements.child_town_city_label).contains('Town or city').should('be.visible')
    cy.get(elements.child_postcode_label).contains('Postcode').should('be.visible').wait(Cypress.env('waitTime'))
//CLILD'S ADDRESS
    cy.get(elements.child_address_line1_textbox).type(secrets.child_line1)
    cy.get(elements.child_address_line2_textbox).type(secrets.child_line2)
    cy.get(elements.child_town_city_textbox).type(secrets.child_town_or_city)
    cy.get(elements.child_postcode_textbox).type(secrets.child_postcode).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const childs_accommodation_step_24 = () => {
    cy.get(elements.main_heading).contains('Will you (the sponsor) be living at this address?').should('be.visible')
    cy.get(elements.child_address_validation_text).should('contain.text', 'CHILDS, ADDRESS, LONDON, NW10 5BD').should('be.visible')
    cy.get(elements.sponsor_living_at_the_same_address_hint).contains("There must be at least one an adult living with the child, but it doesn't have to be you. If you select 'No', we will ask you for this adult's details.")
    cy.get(elements.sponsor_living_at_the_same_address_no_button).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//SPONSOR ADDRESS
export const childs_accommodation_step_26 = () => {
    cy.get(elements.page_heading).contains('Enter the address where you will be living in the UK').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sponsor_address_line1_label).contains('Address line 1').should('be.visible')
    cy.get(elements.sponsor_address_line2_label).contains('Address line 2 (optional)').should('be.visible')
    cy.get(elements.sponsor_town_city_label).contains('Town or city').should('be.visible')
    cy.get(elements.sponsor_postcode_label).contains('Postcode').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sponsor_address_line1_textbox).type(secrets.sponsor_line1)
    cy.get(elements.sponsor_address_line2_textbox).type(secrets.sponsor_line2)
    cy.get(elements.sponsor_town_city_textbox).type(secrets.sponsor_town_or_city)
    cy.get(elements.sponsor_postcode_textbox).type(secrets.sponsor_postcode)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const childs_accommodation_step_27 = () => {
//OVER 16 PERSON LIVING WITH THE CHILD
    cy.get(elements.page_heading).contains('Enter the name of a person over 16 who will live with the child').should('be.visible')
    cy.get(elements.child_address_validation_text).should('contain.text', 'CHILDS, ADDRESS, LONDON, NW10 5BD').should('be.visible')
    cy.get(elements.summary_text).contains(" I'm not sure how to enter their name").wait(Cypress.env('waitTime'))
    cy.get(elements.over16_person_given_names_label).contains('Given names').should('be.visible')
    cy.get(elements.over16_person_family_name_label).contains('Family name').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.over16_person_given_names_textbox).type(secrets.over16_name)
    cy.get(elements.over16_person_family_name_textbox).type(secrets.over16_familyname)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const childs_accommodation_step_28 = () => {
    cy.get(elements.main_heading).contains('You have added 1 person over 16 who will live with the child').should('be.visible')
    cy.get(elements.residents_header).contains('Residents').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.over16_persons_name).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.add_another_person_button).contains('Add another person').should('be.visible')
    cy.get(elements.add_person_continue_button).click().wait(Cypress.env('waitTime'))
}
//VERIFY COMPLETED 2 of 5
export const verify_completed_tasks_2_of_5 = () => {
    alfa.uam_eligibility_tasklist
    cy.get(elements.completed_2_of_5_label).contains('You have completed 2 of 5 sections.').should('be.visible')
    cy.xpath(elements.completed_address).contains('Completed').should('be.visible')
    cy.get(elements.completed_live_there).contains('Completed').should('be.visible').wait(Cypress.env('waitTime'))
}
//RESIDENT'S DETAILS(OVER 16)
export const residents_details_step29 = () => {
    alfa.uam_eligibility_tasklist()
    cy.xpath(elements.residents_details_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains("Enter this person's date of birth").should('be.visible')
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.residents_details_hinttext).contains('For example, 31 3 2010').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.residents_details_day_textbox).type(secrets.over16_day)
    cy.get(elements.residents_details_month_textbox).type(secrets.over16_month)
    cy.get(elements.residents_details_year_textbox).type(secrets.over16_year)
    cy.get(elements.residents_details_continue_button).click().wait(Cypress.env('waitTime'))
}
export const residents_details_step30 = () => {
    cy.get(elements.page_heading).contains('Enter their nationality').should('be.visible')
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.residents_nationality_label).contains('Select their country of nationality').should('be.visible')
    cy.get(elements.residents_nationality_dropdown).select('ZWE - Zimbabwe').should('have.value', 'ZWE - Zimbabwe').wait(Cypress.env('waitTime'))
        .select('RUS - Russia').should('have.value', 'RUS - Russia').wait(Cypress.env('waitTime'))
    cy.get(elements.residents_details_continue_button).click().wait(Cypress.env('waitTime'))
}
export const residents_details_step31 = () => {
    cy.get(elements.page_heading).contains('Do they have any of these identity documents?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.residents_pp_radio_button).should('exist').click().wait(Cypress.env('waitTime'))
    cy.get(elements.residents_pp_number_label).should('be.visible').click()
    cy.get(elements.residents_pp_number_textbox).should('be.visible').type('PASSPORT NUMBER').clear().wait(Cypress.env('waitTime'))
    cy.get(elements.residents_rtdn_radio_button).should('exist').click()
    cy.get(elements.residents_rtdn_number_label).should('be.visible').click()
    cy.get(elements.residents_rtdn_number_textbox).should('be.visible').type('Refugee travel document number').clear().wait(Cypress.env('waitTime'))
    cy.get(elements.residents_ni_radio_button).should('exist').click()
    cy.get(elements.residents_ni_number_label).should('be.visible').click()
    cy.get(elements.residents_ni_number_textbox).should('be.visible').type(secrets.over16_passport_no).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//VERIFY COMPLETED 3 of 5
export const verify_completed_tasks_3_of_5 = () => {
    alfa.uam_eligibility_tasklist
    cy.get(elements.completed_3_of_5_label).contains('You have completed 3 of 5 sections.').should('be.visible')
    cy.xpath(elements.completed_address).contains('Completed').should('be.visible')
    cy.get(elements.completed_live_there).contains('Completed').should('be.visible')
    cy.get(elements.completed_residents_details).contains('Completed').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.not_started_data).contains('Not started').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.not_started_eligibility).contains('Not started').should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.cannot_start_yet).contains('Cannot start yet').should('be.visible').wait(Cypress.env('waitTime'))
}
export const childs_details_step_32 = () => {
    cy.visit('/task-list')
    alfa.uam_eligibility_tasklist
    cy.get(elements.childs_personal_details_link).click()
    cy.get(elements.main_heading).contains("Enter the name of the child you want to sponsor").should('be.visible')
    cy.get(elements.summary_text).contains("I'm not sure how to enter their name").should('be.visible')
    cy.get(elements.childs_personal_details_givennames_label).contains("Given names").should('be.visible')
    cy.get(elements.childs_personal_details_familyname_label).contains("Family name").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.childs_personal_details_givennames_textbox).should('be.visible').type(secrets.child_name)
    cy.get(elements.childs_personal_details_familyname_textbox).should('be.visible').type(secrets.child_familyname).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const childs_details_step_33 = () => {
    cy.get(elements.main_heading).contains("How can we contact the child?").should('be.visible')
    cy.get(elements.childs_personal_details_insettext).contains("TINY BOB").should('be.visible')
    cy.get(elements.cpd_cbcontacted_label).should('be.visible')
    cy.get(elements.cpd_email_checkbox).should('exist').click().wait(Cypress.env('waitTime'))
    cy.get(elements.cpd_phone_checkbox).should('exist').click().wait(Cypress.env('waitTime'))
    cy.get(elements.cpd_email_textkbox).type(secrets.child_email)
    cy.get(elements.cpd_cemail_textbox).type(secrets.child_email)
    cy.get(elements.cpd_pnumber_textkbox).type(secrets.child_phone_no)
    cy.get(elements.cpd_cpnumber_textbox).type(secrets.child_phone_no)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const childs_details_step_34 = () => {
    cy.get(elements.main_heading).contains("Enter their date of birth").should('be.visible')
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.cpd_day_textbox).type(secrets.child_day)
    cy.get(elements.cpd_month_textbox).type(secrets.child_month)
    cy.get(elements.cpd_year_textbox).type(secrets.child_year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const consent_form_step_35 = () => {
    alfa.uam_eligibility_tasklist()
    cy.get(elements.consentform_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains('You must upload 2 completed parental consent forms').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const consent_form_step_36 = () => {
    cy.get(elements.page_heading_xl).contains('Upload the UK sponsorship arrangement consent form').should('be.visible')
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible')
    cy.get(elements.consentform_choosefile_button).attachFile("saconsent.png").wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click()
    cy.get(elements.consentform_completed_tag).should('be.visible').wait(Cypress.env('waitTime'))
}
export const ukrconsent_form_step_37 = () => {
    alfa.uam_eligibility_tasklist()
    cy.get(elements.ukrconsentform_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible')
    cy.get(elements.page_heading_xl).contains('Upload the Ukraine certified consent form').should('be.visible')
    cy.get(elements.ukrconsentform_choosefile_button).attachFile("ukrconsent.png").wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.ukrconsentform_completed_tag).should('be.visible').wait(Cypress.env('waitTime'))
}
//VERIFY COMPLETED
export const verify_completed_tasks_4_of_5 = () => {
    alfa.uam_eligibility_tasklist
    cy.get(elements.completed_4_of_5_label).contains('You have completed 4 of 5 sections.').should('be.visible')
    cy.get(elements.completed_childs_details).contains('Completed').should('be.visible')
    cy.get(elements.completed_consent_form).contains('Completed').should('be.visible')
    cy.get(elements.completed_ukrconsent_form).contains('Completed').should('be.visible')
}
export const confirmation_page_step_38 = () => {
    alfa.uam_eligibility_tasklist()
    cy.get(elements.confirm_data_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Confirm you have read the privacy statement and all people involved agree that the information you have provided can be used for the Homes for Ukraine scheme').should('be.visible')
    cy.get(elements.confirm_data_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const confirmation_page_step_39 = () => {
    alfa.uam_eligibility_tasklist()
    cy.get(elements.confirm_eligibility_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading_xl).contains('Confirm your eligibility to sponsor a child from Ukraine').should('be.visible')
    cy.get(elements.confirm_eligibility_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//CHECK ANSWERS
export const check_answers = () => {
    alfa.uam_eligibility_tasklist()
    cy.get(elements.check_your_answers_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Check your answers before sending your application').should('be.visible')
    cy.xpath(elements.answers_fullname).contains(secrets.full_name)
    cy.get(elements.answers_othernames).contains(secrets.known_by_fullname)
    cy.get(elements.answers_email).contains(secrets.email)
    cy.get(elements.answers_mobile).contains(secrets.mobile)
    cy.get(elements.answers_id).contains('passport')+(secrets.passport_no)
    cy.get(elements.answers_dob).contains(secrets.dob)
    cy.get(elements.answers_nationality).contains("GBR - United Kingdom")
    cy.get(elements.answers_other_nationalities).contains("GBD - British Overseas Territories").wait(Cypress.env('waitTime'))
    cy.get(elements.answers_child_address).contains(secrets.clild_address)
    cy.get(elements.answers_over16_name).contains(secrets.over16_fullname)
    cy.get(elements.answers_child_fullname).contains(secrets.child_fullname)
    cy.get(elements.answers_child_email).contains(secrets.child_email)
    cy.get(elements.answers_child_phone).contains(secrets.child_phone_no)
    cy.get(elements.answers_child_dob).contains(secrets.child_dob)
    cy.get(elements.answers_consent1).contains('saconsent.png')
    cy.get(elements.answers_consent2).contains('ukrconsent.png')
    cy.get(elements.answers_agree1).contains('Agreed')
    cy.get(elements.answers_agree2).contains('Agreed').wait(Cypress.env('waitTime'))
}
//SEND APPLICATION
const send_application = () => {
    cy.get(elements.accept_send).click().wait(Cypress.env('waitTime'))
    cy.get(elements.app_complete_title).contains('Application complete')
    cy.get(elements.ref_number).contains('SPON').should('be.visible').wait(Cypress.env('waitTime'))
}
const validation_error = () => {
    cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
    cy.writeFile('cypress/fixtures/envlinks.txt', { alfa: 'url changed' })
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[*** FAILED TEST *** DUE TO ENVIRONMENT (local/staging/prod) URL CHANGED, ENTER THE CORRECT URL AND RE-RUN THE TEST > >> >>> >>>> >>>>>** ***]()')
    cy.readFile('cypress/fixtures/envlinks.txt').should('not.contains', 'url changed')
    cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
}
export const accept_send = () => {
    let local = ('http://localhost:8080/sponsor-a-child/check-answers');
    let staging = ('https://ukraine-sponsor-resettlement-staging.london.cloudapps.digital/sponsor-a-child/check-answers')
    let prod = ('https://apply-to-offer-homes-for-ukraine.service.gov.uk/sponsor-a-child/check-answers')
    //get the current url and save it in a file
    cy.url().then(envurl => {
        const saveLocation = `cypress/fixtures/envlinks.txt`
        cy.writeFile(saveLocation, { envurl }).wait(Cypress.env('waitTime'))
    })
    //get the url from the saved location and save it as a variable
    cy.readFile(`cypress/fixtures/envlinks.txt`).then((saved_url) => {
        //localhost
        if (saved_url.includes(local)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            send_application()
            cy.log("[This is LOCALHOST / REGISTRATION DETAILS SENT /********** Application complete **********]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '')
            return
        }
        //staging
        else if (saved_url.includes(staging)) {
            cy.url().should("have.contain", 'london.cloudapps.digital')
            send_application()
            cy.log("[This is STAGING / REGISTRATION DETAILS SENT / ********** Application complete **********]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '').wait(5000)
            return
        }
        //prod
        else if (saved_url.includes(prod)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            cy.log('[************* This is PROD / REGISTRATION DETAILS NOT SENT *************]()')
            cy.log('************* **This is PROD / REGISTRATION DETAILS NOT SENT** *************')
            cy.log('[************* This is PROD / REGISTRATION DETAILS NOT SENT *************]()')
            cy.writeFile('cypress/fixtures/envlinks.txt', '')
            return
        }
        else {
            validation_error()
        }
    })
}