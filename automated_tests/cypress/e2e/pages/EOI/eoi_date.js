const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/eoi_bodytext_error.json')
import dayjs from 'dayjs'

const day = dayjs().add(0, 'day').format('DD')
const month = dayjs().add(0, 'month').format('MM')
const month_p_2 = dayjs().add(+2, 'month').format('MM')
const year = dayjs().add(0, 'year').format('YYYY')
const day_p_1 = dayjs().add(+1, 'day').format('DD')
const day_m_1 = dayjs().add(-1, 'day').format('DD')
const year_p_6 = dayjs().add(+6, 'year').format('YYYY')
const startdate_err = () => { cy.get(elements.sdate_error_label).contains('Enter a valid start date').should('be.visible') }
//all fields blank
export const date_null = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sdate_radiobtn_error_label).contains(error.radiobtn_error_msg).should('be.visible')
    cy.get(elements.specific_date_radiobtn_error).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
}
//one field filled
export const date_v1 = () => {
    cy.get(elements.day_textbox_error).clear().type(day)//date
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
    cy.get(elements.day_textbox_error).clear()
    cy.get(elements.month_textbox).clear().type(month)//month
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
    cy.get(elements.day_textbox_error).clear()
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear().type(year)//year
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
}
//two fields filled
export const date_v2 = () => {
    cy.get(elements.day_textbox_error).clear().type('25')//day & month
    cy.get(elements.month_textbox).clear().type('10')
    cy.get(elements.year_textbox).clear()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type('25')//day & year
    cy.get(elements.month_textbox).clear()
    cy.get(elements.year_textbox).clear().type('2020')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
    cy.get(elements.day_textbox_error).clear()//month & year
    cy.get(elements.month_textbox).clear().type('06')
    cy.get(elements.year_textbox).clear().type('2028')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
}
//invalid date (31st Feb)
export const date_v3 = () => {
    cy.get(elements.day_textbox_error).clear().type('31')
    cy.get(elements.month_textbox).clear().type('02')
    cy.get(elements.year_textbox).clear().type(year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
}
//yesterday's date
export const date_v4 = () => {
    cy.get(elements.day_textbox_error).clear().type(day_m_1)
    cy.get(elements.month_textbox).clear().type(month)
    cy.get(elements.year_textbox).clear().type(year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//invalid day
export const date_v5 = () => {
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type('35')
    cy.get(elements.month_textbox).clear().type(day)
    cy.get(elements.year_textbox).clear().type(year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//invalid month
export const date_v6 = () => {
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type(day)
    cy.get(elements.month_textbox).clear().type('18')
    cy.get(elements.year_textbox).clear().type(year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//invalid year
export const date_v7 = () => {
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type(day)
    cy.get(elements.month_textbox).clear().type(month)
    cy.get(elements.year_textbox).clear().type('500')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
//all invalid
export const date_ai = () => {
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type('32')
    cy.get(elements.month_textbox).clear().type('13')
    cy.get(elements.year_textbox).clear().type('-2023')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    startdate_err()
}
//all valid (today's date)
export const date_av = () => {
    startdate_err()
    cy.get(elements.day_textbox_error).clear().type(day)
    cy.get(elements.month_textbox).clear().type(month)
    cy.get(elements.year_textbox).clear().type(year)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible').wait(Cypress.env('waitTime'))
}
//future date
export const date_fu = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible')
    cy.get(elements.sdate_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.day_textbox).clear().type(day_p_1)
    cy.get(elements.month_textbox).clear().type(month_p_2)
    cy.get(elements.year_textbox).clear().type(year_p_6)
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible').wait(Cypress.env('waitTime'))
}