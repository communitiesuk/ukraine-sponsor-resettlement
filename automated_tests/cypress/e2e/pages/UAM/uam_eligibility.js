const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
require('cypress-xpath');

export const uam_start_header = () => { cy.get(elements.main_heading).contains("Apply to provide a safe home for a child from Ukraine").should('be.visible').wait(Cypress.env('waitTime')) }
export const uam_check_header = () => { cy.get(elements.main_heading).contains('Check if you are eligible to use this service').should('be.visible') }
export const uam_step1_header = () => { cy.get(elements.page_heading).contains('Is the child you want to sponsor under 18?').should('be.visible') }
export const uam_step2_header = () => { cy.get(elements.page_heading).contains('Was the child living in Ukraine on or before 31 December 2021?').should('be.visible') }
export const uam_step3_header = () => { cy.get(elements.page_heading).contains('Was the child born after 31 December 2021?').should('be.visible') }
export const uam_step4_header = () => { cy.get(elements.page_heading).contains('Are they travelling to the UK with a parent or legal guardian?').should('be.visible') }
export const uam_step5_header = () => { cy.get(elements.page_heading).contains('Can you upload both consent forms?').should('be.visible') }
export const uam_step6_header = () => { cy.get(elements.page_heading).contains('Can you commit to hosting the child for the minimum period?').should('be.visible') }
export const uam_step7_header = () => { cy.get(elements.page_heading).contains('Do you have permission to live in the UK for the minimum period?').should('be.visible') }
export const uam_step9_header = () => { cy.get(elements.page_heading).contains('You are eligible to use this service').should('be.visible') }
export const uam_tasklist_header = () => { cy.get(elements.page_heading).contains('Apply for approval to provide a safe home for a child from Ukraine').should('be.visible') }

export const show_hide = () => {
    cy.visit('/')
    cy.get('body').then(($body) => {
        if ($body.find(elements.show).length > 0) { //evaluates as show if button exists at all
            cy.get(elements.show).click().wait(Cypress.env('waitTime'))
            cy.get(elements.spchild_link).click().wait(Cypress.env('waitTime'))
        }
        else {
            cy.get(elements.spchild_link).click().wait(Cypress.env('waitTime'))
        }
    })
}

export const uam_eligibility_start = () => {
    show_hide()
    // cy.visit('/start')
    uam_start_header()
    cy.get(elements.startnow_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_check = () => {
    uam_check_header()
    cy.get(elements.page_body).contains(bodytext.check_eligibility_body).should('be.visible')
    cy.get(elements.continue_button_ec).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_1 = () => {
    uam_step1_header()
    cy.get(elements.step1_radio_btn_yes).click()
    cy.get(elements.continue_button).click()
}
export const uam_eligibility_step_2 = () => {
    uam_step2_header()
    cy.get(elements.step2_bodytext).contains(bodytext.step2_bodytext).should('be.visible')
    cy.get(elements.step2_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_3 = () => {
    uam_step3_header()
    cy.get(elements.step3_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_4 = () => {
    uam_step4_header()
    cy.get(elements.step4_bodytext).contains(bodytext.step4_bodytext).should('be.visible')
    cy.get(elements.step4__parent_guardian_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_5 = () => {
    uam_step5_header()
    cy.get(elements.step5_bodytext).contains(bodytext.step5_bodytext).should('be.visible')
    cy.xpath(elements.step5_guidance_link).contains(bodytext.step5_link).should('be.visible')
    cy.get(elements.step5_consent_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_6 = () => {
    uam_step6_header()
    cy.get(elements.summary_text).should('be.visible')
    cy.get(elements.step6_minimum_period_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_7 = () => {
    uam_step7_header()
    cy.get(elements.summary_text).should('be.visible')
    cy.get(elements.step7_minimum_period_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_9 = () => {
    uam_step9_header()
    cy.get(elements.step9_body_text).should('be.visible').contains(bodytext.step9_bodytext).should('be.visible')
    cy.get(elements.step9_start_application_btn).should('be.visible').click()
}
export const uam_eligibility_tasklist = () => {
    uam_tasklist_header()
    cy.get(elements.tasklist_page_body).should('be.visible').contains(bodytext.app_incomplete).should('be.visible')
}


