require('cypress-xpath');
const elements = require('../../page_elements/UAM/uam_elements')
const common = require('./common')

const cannot_uts_heading = () => {cy.get(elements.main_heading).contains('You cannot use this service').should('be.visible') }
export const uam_eli_start = () => {
    cy.visit('/sponsor-a-child/start')
    cy.get(elements.startnow_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button_ec).click().wait(Cypress.env('waitTime'))
}
export const uam_eli_step_1 = () => {
    common.uam_step1_header()
    cy.get(elements.step1_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
export const uam_eli_step_2 = () => {
    cy.visit('/sponsor-a-child/steps/2')
    common.uam_step2_header()
    cy.get(elements.step2_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eli_step_3 = () => {
    cy.visit('/sponsor-a-child/steps/3')
    common.uam_step3_header()
    cy.get(elements.step3_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
export const uam_eli_step_4 = () => {
    cy.visit('/sponsor-a-child/steps/4')
    common.uam_step4_header()
    cy.get(elements.step4_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
export const uam_eli_step_5 = () => {
    cy.visit('/sponsor-a-child/steps/5')
    common.uam_step5_header()
    cy.get(elements.step5_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
export const uam_eli_step_6 = () => {
    cy.visit('/sponsor-a-child/steps/6')
    common.uam_step6_header()
    cy.get(elements.step6_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
export const uam_eli_step_7 = () => {
    cy.visit('/sponsor-a-child/steps/7')
    common.uam_step7_header()
    cy.get(elements.step7_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cannot_uts_heading()
}
