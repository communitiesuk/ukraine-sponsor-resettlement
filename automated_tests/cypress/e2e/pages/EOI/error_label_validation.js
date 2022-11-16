require('cypress-xpath')
const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/bodytext_error.json')
const bodytext = require('../../../fixtures/bodytext.json')
const secrets = require('../../../fixtures/bodytext_secrets.json')


export const eoi_eligibility_check_ev_start = () => {
    cy.visit('/').wait(1000)
    cy.get(elements.coockies_accept).click().wait(500)
    cy.get(elements.hide_coockie_msg).click().wait(1000)
    cy.get(elements.main_heading).contains("Homes for Ukraine: Register to host people already living in the UK").should('be.visible')
    cy.get(elements.start_button).click()
}
export const eoi_eligibility_check_ev_property_suitability = () => {
    cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible')
    cy.get(elements.sa_continue_button).click().wait(200)
    cy.get(elements.error_validation_radio_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.yes_radiobtn).click()
    cy.get(elements.sa_continue_button).click().wait(200)
}
export const eoi_eligibility_check_ev_things_to_consider = () => {
    cy.get(elements.page_heading).contains('Important things to consider').should('be.visible')
    cy.get(elements.sa_continue_button).click().wait(500)
    cy.get(elements.error_validation_radio_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.yes_radiobtn).click()
    cy.get(elements.sa_continue_button).click().wait(500)
}
export const eoi_eligibility_check_ev_6months = () => {
    cy.get(elements.page_heading).contains('Can you commit to hosting for at least 6 months?').should('be.visible')
    cy.get(elements.sa_continue_button).click().wait(200)
    cy.get(elements.error_validation_radio_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.yes_radiobtn).click()
    cy.get(elements.sa_continue_button).click().wait(200)
}

export const eoi_eligibility_check_country = () => {
    cy.get(elements.page_heading).contains('CHOOSE COUNTRY').should('be.visible')
    cy.get(elements.england_radiobtn).click().wait(200)
    cy.get(elements.sa_continue_button).click().wait(1000)
    cy.get(elements.page_heading).contains('Now we need your information').should('be.visible')
    cy.get(elements.sa_continue_button).click().wait(1000)
}

export const your_details_page_ev_s1_3 = () => {
    cy.get(elements.fullname_label).contains('Enter your full name').should('be.visible').wait(500)
    cy.get(elements.fullname_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.fullname_error_label).contains(error.fullname_err_msg).should('be.visible').wait(200)
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.fullname_error_sbox_msg).contains(error.fullname_err_msg).should('be.visible').wait(200)
    cy.get(elements.fullname_error_textbox).clear().type(secrets.user_name)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.email_label).contains('Enter your email address').should('be.visible')
    cy.get(elements.email_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.email_error_label).contains(error.email_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.get(elements.email_error_sbox_msg).contains(error.email_err_msg).should('be.visible').wait(200)
    cy.get(elements.email_error_textbox).clear().type(secrets.email)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.phonenumber_label).contains('Enter your contact telephone number').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.phonenumber_error_label).contains(error.phone_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.pnonenumber_error_sbox_msg).contains(error.phone_err_msg).should('be.visible').wait(200)
    cy.get(elements.phonenumber_error_textbox).clear().type(secrets.phoneno)
    cy.get(elements.continue_button).click().wait(1000)
}

export const residential_address_validation_ev_s4 = () => {
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    cy.get(elements.addressl1_textbox).clear()
    cy.get(elements.addressl2_textbox).clear()
    cy.get(elements.townorcity_textbox).clear()
    cy.get(elements.postcode_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error_label).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error_label).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.addressl1_error_sbox_msg).contains(error.addl1_err_msg).should('be.visible')
    cy.xpath(elements.townorcity_error_sbox_msg).contains(error.townorcity_err_msg).should('be.visible')
    cy.xpath(elements.postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //res address line one 
    cy.get(elements.addressl1_error_textbox).clear().type(secrets.building_no)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error_label).should('not.exist')
    cy.get(elements.townorcity_error_label).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.townorcity_error_sbox_msg).contains(error.townorcity_err_msg).should('be.visible')
    cy.xpath(elements.postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //res address line one and city
    cy.get(elements.townorcity_error_textbox).clear().type(secrets.city)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error_label).should('not.exist')
    cy.get(elements.townorcity_error_label).should('not.exist')
    cy.get(elements.postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.townorcity_error_sbox_msg).should('not.exist')
    cy.xpath(elements.postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //res address line one, city and postcode
    cy.get(elements.postcode_error_textbox).clear().type("NW10 3WE")
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.addressl1_error_label).should('not.exist')
    cy.get(elements.townorcity_error_label).should('not.exist')
    cy.get(elements.postcode_error_label).should('not.exist')
    cy.get(elements.error_summery_title).should('not.exist')
    cy.xpath(elements.addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.townorcity_error_sbox_msg).should('not.exist')
    cy.xpath(elements.postcode_error_sbox_msg).should('not.exist')
}

export const hosting_details_ev_s5 = () => {
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(500)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.difaddress_error_label).should('be.visible').wait(500)
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.difadd_yes_error_radiobtn).click().wait(500)
    cy.get(elements.continue_button).click().wait(1000)
}

export const offering_property_address_validation_ev_s6 = () => {
    cy.get(elements.page_heading).contains("Enter the address of the property you're offering").should('be.visible')
    cy.get(elements.offering_addressl1_textbox).clear()
    cy.get(elements.offering_addressl2_textbox).clear()
    cy.get(elements.offering_townorcity_textbox).clear()
    cy.get(elements.offering_postcode_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    //null values
    cy.get(elements.offering_addressl1_error_label).contains(error.addl1_err_msg).should('be.visible').wait(500)
    cy.get(elements.offering_townorcity_error_label).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.offering_addressl1_error_sbox_msg).contains(error.addl1_err_msg).should('be.visible').wait(500)
    cy.xpath(elements.offering_townorcity_error_sbox_msg).contains(error.townorcity_err_msg).should('be.visible')
    cy.xpath(elements.offering_postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //off address line one 
    cy.get(elements.offering_addressl1_error_textbox).clear().type('Property One Address')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error_label).should('not.exist')
    cy.get(elements.offering_townorcity_error_label).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.offering_addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.offering_townorcity_error_sbox_msg).contains(error.townorcity_err_msg).should('be.visible')
    cy.xpath(elements.offering_postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //off address line one and city
    cy.get(elements.offering_townorcity_error_textbox).clear().type('Gillingham')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error_label).should('not.exist')
    cy.get(elements.offering_townorcity_error_label).should('not.exist')
    cy.get(elements.offering_postcode_error_label).contains(error.postcode_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.offering_addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.offering_townorcity_error_sbox_msg).should('not.exist')
    cy.xpath(elements.offering_postcode_error_sbox_msg).contains(error.postcode_err_msg).should('be.visible')
    //off address line one, city and postcode
    cy.get(elements.offering_postcode_error_textbox).clear().type("KE10 3BB")
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.offering_addressl1_error_label).should('not.exist')
    cy.get(elements.offering_townorcity_error_label).should('not.exist')
    cy.get(elements.offering_postcode_error_label).should('not.exist')
    cy.get(elements.error_summery_title).should('not.exist')
    cy.xpath(elements.offering_addressl1_error_sbox_msg).should('not.exist')
    cy.xpath(elements.offering_townorcity_error_sbox_msg).should('not.exist')
    cy.xpath(elements.offering_postcode_error_sbox_msg).should('not.exist')
}

export const more_properties_ev_s7_8 = () => {
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(1000)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.more_properties_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.more_properties_yes_error_radiobtn).click().wait(500)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.anymore_properties_label).contains(bodytext.more_properties_to_offer).should('be.visible')
    cy.get(elements.continue_button).click().wait(1000)
}

export const how_soon_ev_s9 = () => {
    cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.sdate_radiobtn_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.specific_date_radiobtn_error).click().wait(500)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.sdate_error_label).contains(error.start_date_err_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.sdate_error_sbox_msg).contains(error.start_date_err_msg).should('be.visible').wait(200)
    cy.get(elements.day_textbox_error).clear().type('31')
    cy.get(elements.month_textbox).clear().type('12')
    cy.get(elements.year_textbox).clear().type('2030')
    cy.get(elements.continue_button).click().wait(1000)
}
//changes will be done here
export const no_of_ppl_ev_s10 = () => {
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('exist')
    cy.get(elements.adults_textbox_error).clear().type(6)
    cy.get(elements.children_textbox_error).clear().type(4)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.children_error).should('not.exist')
    cy.get(elements.adults_error).should('not.exist').wait(500)
}

export const accommodation_details_ev_s11 = () => {
    cy.get(elements.page_heading).contains('Who would you like to offer accommodation to? ').should('be.visible')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.accommodation_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(500)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.nopref_radiobtn).click()
    cy.get(elements.continue_button).click().wait(1000)
}

//changes will be done here
export const no_of_bedrooms_ev_s12 = () => {

    cy.get(elements.page_heading).contains('How many bedrooms are available for guests in the property you’re registering now?').should('be.visible')
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.sbedroom_error).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_textbox_error).clear().type(0)
    cy.get(elements.dbbedroom_textbox_error).clear().type(0)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.error_summery_error_list_first).contains(error.number_of_brooms_err_msg).should('be.visible').wait(500)
    cy.get(elements.sbedroom_error).should('not.exist')
    cy.get(elements.dbbedroom_error).should('not.exist').wait(500)
    cy.get(elements.sbedroom_textbox).clear().type(1001)
    cy.get(elements.dbbedroom_textbox).clear().type(1)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.sbedroom_error).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_textbox_error).clear().type(1)
    cy.get(elements.dbbedroom_textbox).clear().type(1001)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.dbbedroom_error).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_textbox).clear().type(4)
    cy.get(elements.dbbedroom_textbox_error).clear().type(2)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.sbedroom_error).should('not.exist')
    cy.get(elements.dbbedroom_error).should('not.exist').wait(500)
}

export const stepfree_access_details_ev_s13 = () => {
    cy.visit('/expression-of-interest/steps/13').wait(1000)
    cy.get(elements.page_heading).contains('Does the property, or any of the properties, have step-free access?').should('be.visible')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.stepfree_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.xpath(elements.error_sbox_sel_option_msg).contains(error.radiobtn_error_msg).should('be.visible').wait(200)
    cy.get(elements.hinttext).contains(bodytext.Stepfree_access_hint).should('be.visible')
    cy.get(elements.stepfree_idk_radiobtn_error).click()
    cy.get(elements.continue_button).click().wait(1000)
}

export const pets_details_ev_s14 = () => {
    cy.get(elements.pets_heading).contains('Would you consider allowing guests to bring their pets?').should('be.visible')
    cy.get(elements.continue_button).click()
    cy.get(elements.pets_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.get(elements.pets_error_sbox_msg).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.pets_no_radiobtn_error).click()
    cy.get(elements.continue_button).click().wait(1000)
}

export const take_part_in_research_ev_s15 = () => {
    cy.get(elements.research_heading).contains('Would you like to take part in research to help us improve the Homes for Ukraine service?').should('be.visible').wait(500)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.research_error_label).contains(error.radiobtn_error_msg).should('be.visible').wait(500)
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.get(elements.research_error_sbox_msg).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.research_no_radiobtn_error).click()
    cy.get(elements.continue_button).click().wait(1000)
}

export const consent_ev_s16 = () => {
    cy.get(elements.consent_heading).contains('Confirm you have read the privacy statement and agree that the information you have provided in this form can be used for the Homes for Ukraine scheme').should('be.visible').wait(500)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.consent_error_label).contains(error.consent_err_msg).should('be.visible').wait(500)
    cy.get(elements.error_summery_title).contains(error.err_summery_title_msg).should('be.visible').wait(200)
    cy.get(elements.consent_error_sbox_msg).contains(error.consent_err_msg).should('be.visible')
    cy.get(elements.consent_checkbox_error).click()
    cy.get(elements.continue_button).click().wait(1000)
}


export const check_your_answers = () => {
    cy.get(elements.page_heading).contains('Check your answers before sending your registration').should('be.visible')
    cy.get(elements.cya_name).contains(secrets.user_name).should('be.visible')
    cy.get(elements.cya_email).contains(secrets.email).should('be.visible')
    cy.get(elements.cya_phone).contains(secrets.phoneno).should('be.visible')
    cy.get(elements.cya_res_address).should("contain.text", 'NW10 3WE')
    cy.get(elements.cya_dif_address).should("contain.text", 'Yes')
    cy.get(elements.cya_p1_address).should("contain.text", 'Property One Address')
    cy.get(elements.cya_more_properties).should("contain.text", 'Yes')
    cy.get(elements.cya_adults).should("contain.text", '6')
    cy.get(elements.cya_children).should("contain.text", '4')
    cy.get(elements.cya_start_date).should("contain.text", '31 December 2030')
    cy.get(elements.cya_accommodate).should("contain.text", 'No Preference')
    cy.get(elements.cya_sbedrooms).should("contain.text", '4')
    cy.get(elements.cya_dbedrooms).should("contain.text", '2')
    cy.get(elements.cya_sf_access).should("contain.text", "I don’t know")
    cy.get(elements.cya_pets).should("contain.text", 'No')
    cy.get(elements.cya_research).should("contain.text", 'No')
    cy.get(elements.cya_pstatement).should("contain.text", 'Agreed')

}









