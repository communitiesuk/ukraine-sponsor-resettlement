require('cypress-xpath');
const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
const common = require('./common')

export const uam_eligibility_start = () => {
    cy.visit('/sponsor-a-child/start')
    common.uam_start_header()
    cy.get(elements.startnow_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_check = () => {
    common.uam_check_header()
    cy.get(elements.page_body).contains(bodytext.check_eligibility_body).should('be.visible')
    cy.get(elements.continue_button_ec).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_1 = () => {
    common.uam_step1_header()
    cy.get(elements.step1_radio_btn_yes).click()
    cy.get(elements.continue_button).click()
}
const uam_eligibility_step_2 = () => {
    common.uam_step2_header()
    cy.get(elements.step2_bodytext).contains(bodytext.step2_bodytext).should('be.visible')
    cy.get(elements.step2_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_3 = () => {
    common.uam_step3_header()
    cy.get(elements.step3_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_4 = () => {
    common.uam_step4_header()
    cy.get(elements.step4_bodytext).contains(bodytext.step4_bodytext).should('be.visible')
    cy.get(elements.step4_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_5 = () => {
    common.uam_step5_header()
    cy.get(elements.step5_bodytext).contains(bodytext.step5_bodytext).should('be.visible')
    cy.xpath(elements.step5_guidance_link).contains(bodytext.step5_link).should('be.visible')
    cy.get(elements.step5_consent_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_6 = () => {
    common.uam_step6_header()
    cy.get(elements.summary_text).should('be.visible')
    cy.get(elements.step6_minimum_period_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_7 = () => {
    common.uam_step7_header()
    cy.get(elements.summary_text).should('be.visible')
    cy.get(elements.step7_minimum_period_radio_btn_yes).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const uam_eligibility_step_9 = () => {
    common.uam_step9_header()
    cy.get(elements.step9_body_text).should('be.visible').contains(bodytext.step9_bodytext).should('be.visible')
    cy.get(elements.step9_start_application_btn).should('be.visible').click()
}
const uam_eligibility_tasklist = () => {
    common.uam_tasklist_header()
    cy.get(elements.tasklist_page_body).should('be.visible').contains(bodytext.app_incomplete).should('be.visible')
}
export const uam_eligibility_steps = () => {
    uam_eligibility_start()
    uam_eligibility_check()
    uam_eligibility_step_1()
    uam_eligibility_step_2()
    uam_eligibility_step_3()
    uam_eligibility_step_4()
    uam_eligibility_step_5()
    uam_eligibility_step_6()
    uam_eligibility_step_7()
    uam_eligibility_step_9()
    uam_eligibility_tasklist()
}
