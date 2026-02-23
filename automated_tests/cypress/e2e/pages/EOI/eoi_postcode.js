require('cypress-xpath')
const elements = require('../../page_elements/EOI/eoi_elements')
const bodytext = require('../../../fixtures/eoi_bodytext.json')

export const scot_address_glas_1 = () => {
    cy.get(elements.addressl1_textbox).clear().type('No 1')
    cy.get(elements.addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.townorcity_textbox).clear().type('Glasgow')
    cy.get(elements.postcode_textbox).clear().type('G33 6BB').wait(Cypress.env('waitTime'))
}
export const scot_address_glas_2 = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Glasgow')
    cy.get(elements.offering_postcode_textbox).clear().type('G1 1BL').wait(Cypress.env('waitTime'))
}
export const scot_address_edinburgh = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Edinburgh')
    cy.get(elements.offering_postcode_textbox).clear().type('EH1 1DD').wait(Cypress.env('waitTime'))
}
export const scot_address_aberdeen = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Aberdeen')
    cy.get(elements.offering_postcode_textbox).clear().type('AB10 1AQ').wait(Cypress.env('waitTime'))
}
export const scot_address_eyemouth = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Eyemouth')
    cy.get(elements.offering_postcode_textbox).clear().type('TD14 5AL').wait(Cypress.env('waitTime'))
}
export const scot_address_newcastleton = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Scotland Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Newcastleton')
    cy.get(elements.offering_postcode_textbox).clear().type('TD9 0QT').wait(Cypress.env('waitTime'))
}
export const eng_address_london_1 = () => {
    cy.get(elements.addressl1_textbox).clear().type('NO 1')
    cy.get(elements.addressl2_textbox).clear().type('England Lane')
    cy.get(elements.townorcity_textbox).clear().type('London')
    cy.get(elements.postcode_textbox).clear().type('NW10 5RN').wait(Cypress.env('waitTime'))
}
export const eng_address_london_2 = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('England Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('London')
    cy.get(elements.offering_postcode_textbox).clear().type('NW10 0AA').wait(Cypress.env('waitTime'))
}
export const eng_address_sheffield = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('England Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Sheffield')
    cy.get(elements.offering_postcode_textbox).clear().type('S1 1GN').wait(Cypress.env('waitTime'))
}
export const eng_address_plymouth = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('England Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Plymouth')
    cy.get(elements.offering_postcode_textbox).clear().type('PL1 1DE').wait(Cypress.env('waitTime'))
}
export const wales_address_cwm = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Cwmbran')
    cy.get(elements.offering_postcode_textbox).clear().type('NP44 3JY').wait(Cypress.env('waitTime'))
}
export const wales_address_broughton = () => {
    cy.get(elements.addressl1_textbox).clear().type('No 1')
    cy.get(elements.addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.townorcity_textbox).clear().type('Broughton')
    cy.get(elements.postcode_textbox).clear().type('CH4 0TD').wait(Cypress.env('waitTime'))
}
export const wales_address_swansea = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Swansea')
    cy.get(elements.offering_postcode_textbox).clear().type('SA1 1DP').wait(Cypress.env('waitTime'))
}
export const wales_address_newport = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Newport')
    cy.get(elements.offering_postcode_textbox).clear().type('NP10 8QQ').wait(Cypress.env('waitTime'))
}
export const wales_address_holyhead = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Holyhead')
    cy.get(elements.offering_postcode_textbox).clear().type('LL65 1AL').wait(Cypress.env('waitTime'))
}
export const wales_address_pembroke = () => {
    cy.get(elements.offering_addressl1_textbox).clear().type('NO 2')
    cy.get(elements.offering_addressl2_textbox).clear().type('Wales Lane')
    cy.get(elements.offering_townorcity_textbox).clear().type('Pembroke')
    cy.get(elements.offering_postcode_textbox).clear().type('SA71 4AP').wait(Cypress.env('waitTime'))
}

//Scotland/Glas
export const postcode_validation_scot_same = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    scot_address_glas_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_no_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How soon can you start hosting someone?').should('be.visible').wait(Cypress.env('waitTime'))
}
//Scotland/Glas:Scotland/Glas
export const postcode_validation_scot_scot = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    scot_address_glas_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    scot_address_glas_2()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//Scotland/Glas:Wales/Cwm
export const postcode_validation_scot_wales = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    scot_address_glas_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    wales_address_cwm()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}
//Scotland/Glas:Eng/London
export const postcode_validation_scot_eng = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    scot_address_glas_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    eng_address_london_2()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//Wales/Broughton
export const postcode_validation_wales_same = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    wales_address_broughton()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_no_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}
//Wales/Broughton:Wales/Swan
export const postcode_validation_wales_wales = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    wales_address_broughton()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    wales_address_swansea()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}
//Wales/Broughton:Scotland/Edin
export const postcode_validation_wales_scot = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    wales_address_broughton()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    scot_address_edinburgh()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//Wales/Broughton:Eng/Sheffield
export const postcode_validation_wales_eng = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    wales_address_broughton()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    eng_address_sheffield()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England:London
export const postcode_validation_eng_same = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_no_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How soon can you start hosting someone?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:England/Plymouth
export const postcode_validation_eng_eng = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    eng_address_plymouth()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Scotland/Aberd
export const postcode_validation_eng_scot = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    scot_address_aberdeen()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Wales/Newport
export const postcode_validation_eng_wales = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    wales_address_newport()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Scotland/Eyemouth
export const postcode_validation_eng_scot_eyem = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    scot_address_eyemouth()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Scotland/Newcastleton
export const postcode_validation_eng_scot_newc = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    scot_address_newcastleton()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Wales/Holyhead
export const postcode_validation_eng_wales_holyh = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    wales_address_holyhead()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}
//England/London:Wales/Pembroke
export const postcode_validation_eng_wales_pemb = () => {
    cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    eng_address_london_1()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    wales_address_pembroke()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains(bodytext.scot_wales_validation_hint).should('be.visible').wait(Cypress.env('waitTime'))
}