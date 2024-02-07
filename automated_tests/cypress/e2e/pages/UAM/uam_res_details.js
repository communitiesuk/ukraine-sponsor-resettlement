require('cypress-xpath');
const secrets = require('../../../fixtures/uam_appdata.json')
const elements = require('../../page_elements/UAM/uam_elements')
const common = require('./common')
const bt_err = require('../../../fixtures/uam_bodytext_err.json')
import dayjs from 'dayjs'

//*******Residents' details(OVER 16)**************Residents' details(OVER 16)**************Residents' details(OVER 16)**************Residents' details(OVER 16)**************
const click_continue = () => {cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))}
const s29_page_heading = () => {cy.get(elements.page_heading).contains("Enter this person's date of birth").should('be.visible')}
const dob_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step29_dob_err_msg).contains(bt_err.dob_err_msg).should('be.visible')
}
const dob_over16_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_over16_err_msg).should('be.visible')
    cy.get(elements.step29_dob_err_msg).contains(bt_err.dob_over16_err_msg).should('be.visible')
}
//path to step29
export const residents_details_step_29 = () => {
    cy.visit('/sponsor-a-child/steps/25')
    cy.get(elements.step25_yes_btn).click()
    click_continue()
    cy.get(elements.step27_gn_textbox).type(secrets.over16_name)
    cy.get(elements.step27_fn_textbox).type(secrets.over16_familyname)
    click_continue()
    common.uam_tasklist_header()
}
//all fields empty: [D: empty, M: empty, Year: empty]
export const residents_details_step_29_v1 = () => {
    cy.xpath(elements.residents_details_link).click().wait(Cypress.env('waitTime'))
    s29_page_heading()
    click_continue()
    dob_err_yes()
    click_continue()
}
//two fields empty: 
export const residents_details_step_29_v2 = () => {
    cy.get(elements.step29_day_err_textbox).type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear()
    cy.get(elements.step29_year_err_textbox).clear()
    click_continue()
    s29_page_heading()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear()
    cy.get(elements.step29_month_err_textbox).type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear()
    click_continue()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear()
    cy.get(elements.step29_month_err_textbox).clear()
    cy.get(elements.step29_year_err_textbox).type(secrets.year)
    click_continue()
    dob_err_yes()
}
//one field empty: 
export const residents_details_step_29_v3 = () => {
    cy.get(elements.step29_day_err_textbox).clear()
    cy.get(elements.step29_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear().type(secrets.year)
    click_continue()
    s29_page_heading()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear()
    cy.get(elements.step29_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear()
    click_continue()
    dob_err_yes()
}
//one field valid: 
export const residents_details_step_29_v4 = () => {
    cy.get(elements.step29_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear().type('x')
    cy.get(elements.step29_year_err_textbox).clear().type('y')
    click_continue()
    s29_page_heading()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type('z')
    cy.get(elements.step29_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear().type('£')
    click_continue()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type('$')
    cy.get(elements.step29_month_err_textbox).clear().type('@')
    cy.get(elements.step29_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
}
//two fields valid: 
export const residents_details_step_29_v5 = () => {
    cy.get(elements.step29_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear().type('100')
    click_continue()
    s29_page_heading()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type('32')
    cy.get(elements.step29_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step29_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
    cy.get(elements.step29_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step29_month_err_textbox).clear().type('14')
    cy.get(elements.step29_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
}

const day = dayjs().add(0, 'day').format('DD')
const month = dayjs().add(0, 'month').format('MM')
const year = dayjs().add(0, 'year').format('YYYY')
const day_p_1 = dayjs().add(+1, 'day').format('DD')
const year_m_15 = dayjs().add(-15, 'year').format('YYYY')
const year_m_18 = dayjs().add(-18, 'year').format('YYYY')
const year_m_1 = dayjs().add(-1, 'year').format('YYYY')
//all valid: future date
export const residents_details_step_29_v6 = (x) => {
    cy.get(elements.step29_day_err_textbox).clear().type(day_p_1)
    cy.get(elements.step29_month_err_textbox).clear().type(month)
    cy.get(elements.step29_year_err_textbox).clear().type(year)
    click_continue()
    s29_page_heading()
    dob_over16_err_yes()
}
 //all valid: past date [1 year ago]  
export const residents_details_step_29_v7 = () => {
    cy.get(elements.step29_day_err_textbox).clear().type(day)
    cy.get(elements.step29_month_err_textbox).clear().type(month)
    cy.get(elements.step29_year_err_textbox).clear().type(year_m_1)
    click_continue()
    s29_page_heading()
    dob_over16_err_yes()
}
//all valid: past date [15 year ago]  
export const residents_details_step_29_v8 = () => {
    cy.get(elements.step29_day_err_textbox).clear().type(day)
    cy.get(elements.step29_month_err_textbox).clear().type(month)
    cy.get(elements.step29_year_err_textbox).clear().type(year_m_15)
    click_continue()
    s29_page_heading()
    dob_over16_err_yes()
}
//all valid: past date [18 year ago]  
export const residents_details_step_29_v9 = () => {
    cy.get(elements.step29_day_err_textbox).clear().type(day)
    cy.get(elements.step29_month_err_textbox).clear().type(month)
    cy.get(elements.step29_year_err_textbox).clear().type(year_m_18)
    click_continue()
    cy.get(elements.page_heading).contains('Enter their nationality').should('be.visible')
}
//******** Identity Documents ************** Identity Documents ************** Identity Documents ************** Identity Documents ************** 
const s31_page_heading = () => {cy.get(elements.page_heading).contains("Do they have any of these identity documents?").should('be.visible')}
const all_error = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step31_id_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
}
const pp_error = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
    cy.get(elements.step31_pp_label).contains(bt_err.pp_err_lbl).should('be.visible')
    cy.get(elements.step31_pp_err_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
}
const ni_error = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
    cy.get(elements.step31_ni_label).contains(bt_err.ni_err_lbl).should('be.visible')
    cy.get(elements.step31_ni_err_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
}
const biom_error = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
    cy.get(elements.step31_biom_label).contains(bt_err.biom_err_lbl).should('be.visible')
    cy.get(elements.step31_biom_err_msg).contains(bt_err.id_doc_err_msg).should('be.visible')
}
//none selected
export const residents_details_step_31_v1 = () => {
    cy.get(elements.step30_nat_dd).select('ZWE - Zimbabwe').should('have.value', 'ZWE - Zimbabwe').wait(Cypress.env('waitTime'))
    click_continue()
    s31_page_heading()
    click_continue()
    all_error()
}
//passport [min requirement valid 6 characters (letters & numbers)]
export const residents_details_step_31_v2 = () => {
    cy.get(elements.step31_pp_err_radio_btn).click()
    click_continue()
    pp_error()
    cy.get(elements.step31_pp_err_textbox).should('be.visible').clear().type('PASS1').wait(Cypress.env('waitTime'))
    click_continue()
    pp_error()
    cy.get(elements.step31_pp_err_textbox).should('be.visible').clear().type('$$$$$$$$').wait(Cypress.env('waitTime'))
    click_continue()
    pp_error()
    cy.get(elements.step31_pp_err_textbox).should('be.visible').clear().type('£PASS123').wait(Cypress.env('waitTime'))
    click_continue()
    pp_error()
}
//national id
export const residents_details_step_31_v3 = () => {
    cy.get(elements.step31_ni_err_radio_btn).click()
    click_continue()
    ni_error()
    cy.get(elements.step31_ni_err_textbox).should('be.visible').clear().type('NINO1').wait(Cypress.env('waitTime'))
    click_continue()
    ni_error()
    cy.get(elements.step31_ni_err_textbox).should('be.visible').clear().type('££££££££').wait(Cypress.env('waitTime'))
    click_continue()
    ni_error()
    cy.get(elements.step31_ni_err_textbox).should('be.visible').clear().type('£NINUM123').wait(Cypress.env('waitTime'))
    click_continue()
    ni_error()
}
//biometric residence
export const residents_details_step_31_v4 = () => {
    cy.get(elements.step31_biom_err_radio_btn).click()
    click_continue()
    refu_error()
    cy.get(elements.step31_biom_err_textbox).should('be.visible').clear().type('BIOM1').wait(Cypress.env('waitTime'))
    click_continue()
    refu_error()
    cy.get(elements.step31_biom_err_textbox).should('be.visible').clear().type('@@££$$&&**').wait(Cypress.env('waitTime'))
    click_continue()
    refu_error()
    cy.get(elements.step31_biom_err_textbox).should('be.visible').clear().type('£BIOM123').wait(Cypress.env('waitTime'))
    click_continue()
    refu_error()
}
//I don't have any of these
export const residents_details_step_31_v5 = () => {
    cy.get(elements.step31_idha_radio_btn).click()
    click_continue()
    common.uam_tasklist_header()
}