const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/bodytext_error.json')
const bodytext = require('../../../fixtures/bodytext.json')

//NULL
export const bedrooms_null = () => {
    cy.visit('/expression-of-interest/steps/12')
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How many bedrooms are available for guests in the property you’re registering now?').should('be.visible')
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
}
//0-0
export const bedrooms_v1 = () => {
    cy.get(elements.sbedroom_textbox_error).clear().type(0)
    cy.get(elements.dbbedroom_textbox_error).clear().type(0)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.error_summary_error_list_first).contains(error.number_of_brooms_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist').wait(Cypress.env('waitTime'))
}
//0-NULL
export const bedrooms_v2 = () => {
    cy.get(elements.sbedroom_textbox).clear().type(0)
    cy.get(elements.dbbedroom_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.error_summary_error_list_first).contains(error.number_of_brooms_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist').wait(Cypress.env('waitTime'))
}
//NULL-0
export const bedrooms_v3 = () => {
    cy.get(elements.sbedroom_textbox).clear()
    cy.get(elements.dbbedroom_textbox).clear().type(0)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.error_summary_error_list_first).contains(error.number_of_brooms_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist').wait(Cypress.env('waitTime'))
}
//5-NULL
export const bedrooms_v4 = () => {
    cy.get(elements.sbedroom_textbox).clear().type(5)
    cy.get(elements.dbbedroom_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
}
//NULL-8
export const bedrooms_v5 = () => {
    cy.get(elements.sbedroom_textbox).clear()
    cy.get(elements.dbbedroom_textbox_error).clear().type(8)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist')
}
//11-15
export const bedrooms_v6 = () => {
    cy.get(elements.sbedroom_textbox_error).clear().type(11)
    cy.get(elements.dbbedroom_textbox).clear().type(15)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
}
//9-11
export const bedrooms_v7 = () => {
    cy.get(elements.sbedroom_textbox_error).clear().type(9)
    cy.get(elements.dbbedroom_textbox_error).clear().type(11)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
}
//11-9
export const bedrooms_v8 = () => {
    cy.get(elements.sbedroom_textbox).clear().type(11)
    cy.get(elements.dbbedroom_textbox_error).clear().type(9)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_error_label).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should("contain.text", "You must enter a number from 0 to 9")
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist') 
}
//0-9
export const bedrooms_v9 = () => {
    cy.get(elements.sbedroom_textbox_error).clear().type(0)
    cy.get(elements.dbbedroom_textbox).clear().type(9)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('not.exist').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).should("contain.text","Does the property, or any of the properties, have step-free access?")
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist') 
}
//9-0
export const bedrooms_v10 = () => {
    cy.visit('/expression-of-interest/steps/12')
    cy.get(elements.sbedroom_textbox).clear().type(9)
    cy.get(elements.dbbedroom_textbox).clear().type(0)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hinttext).contains(bodytext.bedrooms_hint).should('not.exist').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).should("contain.text","Does the property, or any of the properties, have step-free access?")
    cy.get(elements.sbedroom_error_label).should('not.exist')
    cy.get(elements.dbbedroom_error_label).should('not.exist')
    cy.get(elements.sbedroom_error_sbox_msg).should('not.exist')
    cy.get(elements.dbbedroom_error_sbox_msg).should('not.exist') 
}