const elements = require('../../page_elements/EOI/eoi_elements')

const property_suitability_page = () => {
    cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible')
}
const click_continue = () => {
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
}
const important_things_page = () => {
    cy.get(elements.page_heading).contains('Important things to consider').should('be.visible')
}
const click_back_link = () => {
    cy.get(elements.back_link).click().wait(Cypress.env('waitTime'))
}
const other_ways_you_can_help_page = () => {
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
}

export const eoi_eligibility_check_start = () => {
    cy.visit('/')
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains("Homes for Ukraine: Register to host people already living in the UK").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.start_button).click().wait(Cypress.env('waitTime'))
}
export const eoi_eligibility_check_property_suitability = () => {
    property_suitability_page()
    cy.get(elements.no_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
    other_ways_you_can_help_page()
    click_back_link()
    property_suitability_page()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const eoi_eligibility_check_imp_things = () => {
    important_things_page()
    cy.get(elements.no_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
    other_ways_you_can_help_page()
    click_back_link()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const eoi_eligibility_check_hosting_6months = () => {
    cy.get(elements.page_heading).contains('Can you commit to hosting for at least 6 months?').should('be.visible')
    cy.get(elements.no_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
    other_ways_you_can_help_page()
    click_back_link()
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const eoi_eligibility_check_need_information = () => {
    cy.get(elements.page_heading).contains('Now we need your information').should('be.visible')
    click_continue()
    cy.get(elements.fullname_label).contains('Enter your full name').should('be.visible').wait(Cypress.env('waitTime'))
}
