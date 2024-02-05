const elements = require('../../page_elements/UAM/uam_elements')

export const uam_start_header = () => { cy.get(elements.main_heading).contains("Apply to provide a safe home for a child from Ukraine").should('be.visible').wait(Cypress.env('waitTime'))}
export const uam_check_header = () => { cy.get(elements.main_heading).contains('Check if you are eligible to use this service').should('be.visible')}
export const uam_step1_header = () => { cy.get(elements.page_heading).contains('Is the person you want to sponsor under 18?').should('be.visible')}
export const uam_step2_header = () => { cy.get(elements.page_heading).contains('Was the child living in Ukraine before 1 January 2022?').should('be.visible')}
export const uam_step3_header = () => { cy.get(elements.page_heading).contains('Was the child born after 31 December 2021?').should('be.visible') }
export const uam_step4_header = () => { cy.get(elements.page_heading).contains('Are they applying for a visa under the Homes for Ukraine Scheme with their parent or legal guardian, or to join them in the UK?').should('be.visible')}
export const uam_step5_header = () => { cy.get(elements.page_heading).contains('Can you upload both consent forms?').should('be.visible')}
export const uam_step6_header = () => { cy.get(elements.page_heading).contains('Can you commit to hosting the child for the minimum period?').should('be.visible')}
export const uam_step7_header = () => { cy.get(elements.page_heading).contains('Do you have permission to live in the UK for the minimum period?').should('be.visible')}
export const uam_step9_header = () => { cy.get(elements.page_heading).contains('You are eligible to use this service').should('be.visible')}
export const uam_tasklist_header = () => { cy.get(elements.page_heading).contains('Apply for approval to provide a safe home for a child from Ukraine').should('be.visible')}
export const uam_step10_header = () => { cy.get(elements.page_heading).contains('Enter your name').should('be.visible')}
export const uam_step12_header = () => { cy.get(elements.page_heading).contains('Add your other name').should('be.visible')}
export const uam_step13_header = () => { cy.get(elements.page_heading).should('include.text', 'You have added').should('be.visible')}
export const uam_step14_header = () => { cy.get(elements.page_heading).contains('Enter your email address').should('be.visible')}
export const uam_step15_header = () => { cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible')}
export const uam_step16_header = () => { cy.get(elements.page_heading).contains('Do you have any of these identity documents?').should('be.visible')}
export const uam_step18_header = () => { cy.get(elements.page_heading).contains('Enter your date of birth').should('be.visible')}
export const uam_step19_header = () => { cy.get(elements.page_heading).contains('Enter your nationality').should('be.visible')}
export const uam_step20_header = () => { cy.get(elements.page_heading).contains('Have you ever held any other nationalities?').should('be.visible')}
export const uam_step21_header = () => { cy.get(elements.page_heading).contains('Enter your other nationality').should('be.visible')}
export const uam_step23_header = () => { cy.get(elements.page_heading).contains('Enter the address where the child will be living in the UK').should('be.visible')}
export const uam_step25_header = () => { cy.get(elements.page_heading).contains('Will anyone else over the age of 16 be living at this address?').should('be.visible')}
export const uam_step27_header = () => { cy.get(elements.page_heading).contains('Enter the name of a person over 16 who will live with the child').should('be.visible')}
export const uam_step32_header = () => { cy.get(elements.page_heading).contains('Enter the name of the child you want to sponsor').should('be.visible')}
export const uam_step33_header = () => { cy.get(elements.page_heading).contains('How can we contact the child?').should('be.visible')}
export const uam_step34_header = () => { cy.get(elements.page_heading).contains('Enter their date of birth').should('be.visible')}
export const uam_step35_header = () => { cy.get(elements.page_heading).contains('You must upload 2 completed parental consent forms').should('be.visible')}
export const uam_step36_header = () => { cy.get(elements.page_heading_xl).contains('Upload the UK sponsorship arrangement consent form').should('be.visible')}
export const uam_step37_header = () => { cy.get(elements.page_heading_xl).contains('Upload the Ukraine certified consent form').should('be.visible')}
export const uam_step38_header = () => { cy.get(elements.page_heading).contains('Confirm you have read the privacy statement').should('be.visible')}
export const uam_step39_header = () => { cy.get(elements.page_heading_xl).contains('Confirm your eligibility to sponsor a child from Ukraine').should('be.visible')}
