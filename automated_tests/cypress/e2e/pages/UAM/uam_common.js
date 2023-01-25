const elements = require('../../page_elements/UAM/uam_elements')

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

