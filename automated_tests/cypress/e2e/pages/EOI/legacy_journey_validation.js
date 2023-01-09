const elements = require('../../page_elements/EOI/eoi_elements')
const bodytext = require('../../../fixtures/bodytext.json')

const sa_page_1_heading = () => {cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible').wait(Cypress.env('waitTime'))
cy.get(elements.second_header).contains(bodytext.home_is_suitable).should('be.visible').wait(Cypress.env('waitTime'))
}
//individual
export const eoi_ind_step_1_3 = () => {
    cy.visit('/individual/steps/1')
    sa_page_1_heading()
    cy.visit('/individual/steps/2')
    sa_page_1_heading()
    cy.visit('/individual/steps/3')
    sa_page_1_heading()
}
export const eoi_ind_step_4_6 = () => {
    cy.visit('/individual/steps/4')
    sa_page_1_heading()
    cy.visit('/individual/steps/5')
    sa_page_1_heading()
    cy.visit('/individual/steps/6')
    sa_page_1_heading()
}
export const eoi_ind_step_7_8= () => {
    cy.visit('/individual/steps/7')
    sa_page_1_heading()
    cy.visit('/individual/steps/8')
    sa_page_1_heading()
    cy.visit('/individual/steps/9')
    sa_page_1_heading()
}
export const eoi_ind_step_9 = () => {
    cy.visit('/individual/steps/9')
    sa_page_1_heading()
    cy.get(elements.page_heading).should('not.include.text', "How many people normally live in the property you’re offering (not including guests)?").wait(Cypress.env('waitTime'))
}
export const eoi_ind_step_10_12 = () => {
    cy.visit('/individual/steps/10')
    sa_page_1_heading()
    cy.visit('/individual/steps/11')
    sa_page_1_heading()
    cy.visit('/individual/steps/12')
    sa_page_1_heading()
}
export const eoi_ind_step_13_15 = () => {
    cy.visit('/individual/steps/13')
    sa_page_1_heading()
    cy.visit('/individual/steps/14')
    sa_page_1_heading()
    cy.visit('/individual/steps/15')
    sa_page_1_heading()
}
export const eoi_ind_step_16_17 = () => {
    cy.visit('/individual/steps/16')
    sa_page_1_heading()
    cy.visit('/individual/steps/17')
    sa_page_1_heading()
    cy.wait(Cypress.env('waitTime'))
}
//organisation
export const eoi_org_step_1_3 = () => {
    cy.visit('/organisation/steps/1')
    sa_page_1_heading()
    cy.visit('/organisation/steps/2')
    sa_page_1_heading()
    cy.visit('/organisation/steps/3')
    sa_page_1_heading()
}
export const eoi_org_step_4_6 = () => {
    cy.visit('/organisation/steps/4')
    sa_page_1_heading()
    cy.visit('/organisation/steps/5')
    sa_page_1_heading()
    cy.visit('/organisation/steps/6')
    sa_page_1_heading()
}
export const eoi_org_step_7_9 = () => {
    cy.visit('/organisation/steps/7')
    sa_page_1_heading()
    cy.visit('/organisation/steps/8')
    sa_page_1_heading()
    cy.visit('/organisation/steps/9')
    sa_page_1_heading()
}
export const eoi_org_step_10_12 = () => {
    cy.visit('/organisation/steps/10')
    sa_page_1_heading()
    cy.visit('/organisation/steps/11')
    sa_page_1_heading()
    cy.visit('/organisation/steps/12')
    sa_page_1_heading()
}
export const eoi_org_step_13_15 = () => {
    cy.visit('/organisation/steps/13')
    sa_page_1_heading()
    cy.visit('/organisation/steps/14')
    sa_page_1_heading()
    cy.visit('/organisation/steps/15')
    sa_page_1_heading()
}
export const eoi_org_step_16_17 = () => {
    cy.visit('/organisation/steps/16')
    sa_page_1_heading()
    cy.visit('/organisation/steps/17')
    sa_page_1_heading()
    cy.wait(Cypress.env('waitTime'))
}
//additional-info
export const eoi_ad_info_step_1_3 = () => {
    cy.visit('/additional-info/steps/1')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/2')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/3')
    sa_page_1_heading()
}
export const eoi_ad_info_step_4_6 = () => {
    cy.visit('/additional-info/steps/4')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/5')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/6')
    sa_page_1_heading()
}
export const eoi_ad_info_step_7_9 = () => {
    cy.visit('/additional-info/steps/7')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/8')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/9')
    sa_page_1_heading()
}
export const eoi_ad_info_step_10_11 = () => {
    cy.visit('/additional-info/steps/10')
    sa_page_1_heading()
    cy.visit('/additional-info/steps/11')
    sa_page_1_heading()
    cy.wait(Cypress.env('waitTime'))
}
export const eoi_ad_info_check_ans = () => {
    cy.visit('/additional-info/check-answers').wait(Cypress.env('waitTime'))
    sa_page_1_heading()
    cy.get(elements.page_heading).should('not.include.text', "Check your answers before sending your application").wait(Cypress.env('waitTime'))
}
