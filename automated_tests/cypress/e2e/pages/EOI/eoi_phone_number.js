const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/eoi_bodytext_error.json')
const secrets = require('../../../fixtures/eoi_bodytext_secrets.json')

const coockie_accept = () => {
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
}
const residential_address_page = () => {
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
}
const phone_nm_error = () => {
    cy.get(elements.phonenumber_error_label).contains(error.phone_err_msg).should('be.visible')
    cy.get(elements.error_summary_title).contains(error.err_summary_title_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.pnonenumber_error_sbox_msg).contains(error.phone_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
}
//invalid
export const phone_blank = () => {
    cy.visit('/expression-of-interest/steps/3')
    coockie_accept()
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_letters = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('ABCDEFGHIJK')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_special_characters = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('£££££@@@@@!')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_letters_special_characters = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('ABCDE@@@@@!')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_nums_letters = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('12345ABCDEF')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_nums_special_characters = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('12345@@@@@!')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_10_digits = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('0754567890')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_14_digits = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('07745678901234')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_10digits_plus = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('+1234567890')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
//valid
export const phone_11_digits = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('12345678901')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_12_digits = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('123456789012')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_13_digits = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('1234567890123')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_lndline = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('02021230000')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_plus = () => {
    cy.visit('/expression-of-interest/steps/3')
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001 or +44 808 157 0192').should('be.visible')
    cy.get(elements.phonenumber_textbox).clear().type('+447533165941')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
//error page invalid
export const phone_err_special_charactors = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('ABCDE@@@@@!')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_err_10_digits = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('0754567890')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
export const phone_err_10_digits_plus = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('+1234567890')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    phone_nm_error()
}
//error page invalid
export const phone_err_11_digits = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('12345678901')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_err_landline = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('02021230000')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
export const phone_err_plus = () => {
    phone_letters()
    cy.get(elements.phonenumber_error_textbox).clear().type('+447533165941')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    residential_address_page()
}
