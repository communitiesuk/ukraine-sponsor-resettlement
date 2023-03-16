const elements = require('../../page_elements/EOI/eoi_elements')
const bodytext = require('../../../fixtures/eoi_bodytext.json')
const secrets = require('../../../fixtures/eoi_bodytext_secrets.json')

const back_link = () => {cy.get(elements.back_link).click().wait(Cypress.env('waitTime'))}
const sa_page_1_heading = () => {cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible')}
const sa_page_2_heading = () => {cy.get(elements.page_heading).contains('Important things to consider').should('be.visible')}
const sa_page_3_heading = () => {cy.get(elements.page_heading).contains('Can you commit to hosting for at least 6 months?').should('be.visible')}
const sa_page_4_heading = () => {cy.get(elements.page_heading).contains('Now we need your information').should('be.visible')}
const name_heading_step_1 = () => {cy.get(elements.fullname_label).contains('Enter your full name').should('be.visible').wait(Cypress.env('waitTime'))}
const email_heading_step_2 = () => {cy.get(elements.email_label).contains('Enter your email address').should('be.visible').wait(Cypress.env('waitTime'))}
const phone_heading_step_3 = () => {cy.get(elements.phonenumber_label).contains('Enter your contact telephone number').should('be.visible').wait(Cypress.env('waitTime'))}
const residential_address_heading_step_4 = () => {cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))}
const dif_address_ques_heading_step_5 = () => {cy.get(elements.page_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))}
const offering_address_heading_step_6 = () => {cy.get(elements.page_heading).contains("Enter the address of the property you're offering").should('be.visible').wait(Cypress.env('waitTime'))}
const more_properties_heading_step_7 = () => {cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))}
const how_soon_heading_step_9 = () => {cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible').wait(Cypress.env('waitTime'))}
const how_many_people_heading_step_10 = () => {cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible')}
const offer_accommodation_heading_step_11 = () => {cy.get(elements.page_heading).contains('Who would you like to offer accommodation to? ').should('be.visible').wait(Cypress.env('waitTime'))}
const bedrooms_heading_step_12 = () => {cy.get(elements.page_heading).contains('How many bedrooms are available for guests in the property you’re registering now?').should('be.visible').wait(Cypress.env('waitTime'))}
const stepfree_access_heading_step_13 = () => {cy.get(elements.page_heading).contains('Does the property, or any of the properties, have step-free access?').should('be.visible').wait(Cypress.env('waitTime'))}
const pets_heading_step_14 = () => {cy.get(elements.pets_heading).contains('Would you consider allowing guests to bring their pets?').should('be.visible').wait(Cypress.env('waitTime'))}
const research_heading_step_15 = () => {cy.get(elements.research_heading).contains('Would you like to take part in research to help us improve the Homes for Ukraine service?').should('be.visible').wait(Cypress.env('waitTime'))}
const privercy_heading_step_16 = () => {cy.get(elements.consent_heading).contains('Confirm you have read the privacy statement and agree that the information you have provided in this form can be used for the Homes for Ukraine scheme').should('be.visible').wait(Cypress.env('waitTime'))}
const check_answers_heading_step_17 = () => {cy.get(elements.page_heading).contains('Check your answers before sending your registration').should('be.visible').wait(Cypress.env('waitTime'))}

export const eoi_eligibility_check_p1_2 = () => {
    cy.visit('/')
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains("Homes for Ukraine: Register to host people already living in the UK").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.start_button).click().wait(Cypress.env('waitTime'))
    sa_page_1_heading()
    back_link()
    cy.get(elements.main_heading).contains("Homes for Ukraine: Register to host people already living in the UK").should('be.visible').wait(Cypress.env('waitTime'))
}
export const eoi_eligibility_check_p2_3 = () => {
    cy.visit('/expression-of-interest/self-assessment/property-suitable')
    sa_page_1_heading()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    sa_page_2_heading()
    back_link()
    sa_page_1_heading()
}
export const eoi_eligibility_check_p3_4 = () => {
    cy.visit('/expression-of-interest/self-assessment/challenges')
    sa_page_2_heading()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    sa_page_3_heading()
    back_link()
    sa_page_2_heading()
}
export const eoi_eligibility_check_p4_5 = () => {
    cy.visit('/expression-of-interest/self-assessment/can-you-commit')
    sa_page_3_heading()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    sa_page_4_heading()
    back_link()
    sa_page_3_heading()
}
//Enter your full name
export const your_details_name_s1 = () => {
    cy.visit('/expression-of-interest/self-assessment/your-info')
    sa_page_4_heading()
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    name_heading_step_1()
    back_link()
    sa_page_4_heading()
}
//Enter your email address
export const your_details_email_s2 = () => {
    cy.visit('/expression-of-interest/steps/1')
    name_heading_step_1()
    cy.get(elements.fullname_textbox).clear().type(secrets.user_name).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    email_heading_step_2()
    back_link()
    name_heading_step_1()
}
//telephone number
export const your_details_phone_s3 = () => {
    cy.visit('/expression-of-interest/steps/2')
    email_heading_step_2()
    cy.get(elements.email_textbox).clear().type(secrets.email).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_heading_step_3()
    back_link()
    email_heading_step_2()
}
//residential address
export const your_details_resaddress_s4 = () => {
    cy.visit('/expression-of-interest/steps/3')
    phone_heading_step_3()
    cy.get(elements.phonenumber_textbox).clear().type(secrets.phoneno).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_heading_step_4()
    back_link()
    phone_heading_step_3()
}
//offering at a different address to your home?
export const dif_address_to_your_home_s5 = () => {
    cy.visit('/expression-of-interest/steps/4')
    residential_address_heading_step_4()
    cy.get(elements.addressl1_textbox).clear().type(secrets.building_no)
    cy.get(elements.addressl2_textbox).clear().type(secrets.street)
    cy.get(elements.townorcity_textbox).clear().type(secrets.city)
    cy.get(elements.postcode_textbox).clear().type('NW10 3WE').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    dif_address_ques_heading_step_5()
    back_link()
    residential_address_heading_step_4()
}
//offering property address
export const offering_property_address_s6 = () => {
    cy.visit('/expression-of-interest/steps/5')
    dif_address_ques_heading_step_5()
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    offering_address_heading_step_6()
    back_link()
    dif_address_ques_heading_step_5()
}
//offering any more properties 
export const any_more_properties_s7 = () => {
    cy.visit('/expression-of-interest/steps/6')
    offering_address_heading_step_6()
    cy.get(elements.offering_addressl1_textbox).clear().type('Property One Address').wait(Cypress.env('waitTime'))
    cy.get(elements.offering_addressl2_textbox).clear().type(secrets.street)
    cy.get(elements.offering_townorcity_textbox).clear().type(secrets.city)
    cy.get(elements.offering_postcode_textbox).clear().type('KT20 3KE').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    more_properties_heading_step_7()
    back_link()
    offering_address_heading_step_6()
}
//share information about any more properties
export const share_info_more_properties_s8 = () => {
    cy.visit('/expression-of-interest/steps/7')
    more_properties_heading_step_7()
    cy.get(elements.more_properties_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.anymore_properties_label).contains(bodytext.more_properties_to_offer).should('be.visible')
    back_link()
    more_properties_heading_step_7()
}
//start hosting someone?
export const hosting_someone_s9 = () => {
    cy.visit('/expression-of-interest/steps/8')
    cy.get(elements.anymore_properties_label).contains(bodytext.more_properties_to_offer).should('be.visible')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    how_soon_heading_step_9()
    back_link()
    cy.get(elements.anymore_properties_label).contains(bodytext.more_properties_to_offer).should('be.visible')
}
//how many people living
export const how_many_people_s10 = () => {
    cy.visit('/expression-of-interest/steps/9')
    how_soon_heading_step_9()
    cy.get(elements.asap_radiobtn).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    how_many_people_heading_step_10()
    back_link()
    how_soon_heading_step_9()
}
//offer accommodation to
export const offer_accommodation_to_s11 = () => {
    cy.visit('/expression-of-interest/steps/10')
    how_many_people_heading_step_10()
    cy.get(elements.adults_textbox).clear().type('6')
    cy.get(elements.children_textbox).clear().type('4')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    offer_accommodation_heading_step_11()
    back_link()
    how_many_people_heading_step_10()
}
//bedrooms
export const bedroom_details_s12 = () => {
    cy.visit('/expression-of-interest/steps/11')
    offer_accommodation_heading_step_11()
    cy.get(elements.morethanone_radiobtn).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    bedrooms_heading_step_12()
    back_link()
    offer_accommodation_heading_step_11()
}
//step free access
export const stepfree_access_s13 = () => {
    cy.visit('/expression-of-interest/steps/12')
    bedrooms_heading_step_12()
    cy.get(elements.sbedroom_textbox).clear().type('4')
    cy.get(elements.dbbedroom_textbox).clear().type('2').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    stepfree_access_heading_step_13()
    back_link()
    bedrooms_heading_step_12()
}
//pets
export const pets_s14 = () => {
    cy.visit('/expression-of-interest/steps/13')
    stepfree_access_heading_step_13()
    cy.get(elements.stepfree_yta_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    pets_heading_step_14()
    back_link()
    stepfree_access_heading_step_13()
}
//research
export const take_part_in_research_s15 = () => {
    cy.visit('/expression-of-interest/steps/14')
    pets_heading_step_14()
    cy.get(elements.pets_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    research_heading_step_15()
    back_link()
    pets_heading_step_14()
}
//consent
export const consent_s16 = () => {
    cy.visit('/expression-of-interest/steps/15')
    research_heading_step_15()
    cy.get(elements.research_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    privercy_heading_step_16()
    back_link()
    research_heading_step_15() 
}
//answers
export const check_your_answers_s17 = () => {
    cy.visit('/expression-of-interest/steps/16')
    privercy_heading_step_16()
    cy.get(elements.consent_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    check_answers_heading_step_17()
    back_link()
    privercy_heading_step_16()
}