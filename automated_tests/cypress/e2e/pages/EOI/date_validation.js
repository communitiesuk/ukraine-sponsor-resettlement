const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/bodytext_error.json')

export const date_null = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.get(elements.cookies_accept).click().wait(250)
    cy.get(elements.hide_cookie_msg).click().wait(250)
    cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible')
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_radiobtn_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.specific_date_radiobtn_error).click().wait(250)
    cy.get(elements.continue_button).click().wait(250)

}

export const date_v1 = () => {
    cy.get(elements.day_textbox_error).clear().type('20')
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear()
    cy.get(elements.month_textbox).clear().type('12')
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear()
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear().type('2025')
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
}

export const date_v2 = () => {
    //day & month
    cy.get(elements.day_textbox_error).clear().type('25')
    cy.get(elements.month_textbox).clear().type('10')
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    //day & year
    cy.get(elements.day_textbox_error).clear().type('25')
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear().type('2020')
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    //month & year
    cy.get(elements.day_textbox_error).clear()
    cy.get(elements.month_textbox).clear().type('06')
    cy.get(elements.year_textbox).clear().type('2028')
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
}

//invalid date
export const date_v3 = () => {
    cy.get(elements.day_textbox_error).clear().type('31')
    cy.get(elements.month_textbox).clear().type('02')
    cy.get(elements.year_textbox).clear().type('2023')
    cy.get(elements.continue_button).click().wait(250)
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
}

//before today's date
export const date_v4 = () => {
    cy.get(elements.day_textbox_error).clear().type('20')
    cy.get(elements.month_textbox).clear().type('05')
    cy.get(elements.year_textbox).clear().type('2021')
    cy.get(elements.continue_button).click().wait(250)
}

//invalid day
export const date_v5 = () => {
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear().type('35')
    cy.get(elements.month_textbox).clear().type('02')
    cy.get(elements.year_textbox).clear().type('2023')
    cy.get(elements.continue_button).click().wait(250)
}

//invalid month
export const date_v6 = () => {
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear().type('15')
    cy.get(elements.month_textbox).clear().type('18')
    cy.get(elements.year_textbox).clear().type('2023')
    cy.get(elements.continue_button).click().wait(250)
}

//invalid year
export const date_v7 = () => {
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear().type('15')
    cy.get(elements.month_textbox).clear().type('12')
    cy.get(elements.year_textbox).clear().type('500')
    cy.get(elements.continue_button).click().wait(250)
}

//all valid
export const date_av = () => {
    cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible')
    cy.get(elements.day_textbox_error).clear().type('31')
    cy.get(elements.month_textbox).clear().type('12')
    cy.get(elements.year_textbox).clear().type('2030')
    cy.get(elements.continue_button).click().wait(250)
}

export const no_of_people_living_page = () => {
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible').wait(500)
}
