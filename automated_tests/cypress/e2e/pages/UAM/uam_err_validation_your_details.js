require('cypress-xpath');
const secrets = require('../../../fixtures/uam_appdata.json')
const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
const common = require('./common')
const bt_err = require('../../../fixtures/uam_bodytext_err.json')
const eligibility = require('./eligibility')

//Eligibility Steps
export const uam_eligibility_step1_9 = () => {
    eligibility.uam_eligibility_steps()
}
//*******SPONSOR NAME**************SPONSOR NAME**************SPONSOR NAME**************SPONSOR NAME**************SPONSOR NAME*******
const click_continue = () => {
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const s10_page_heading = () => {
    cy.get(elements.page_heading).contains('Enter your name').should('be.visible')
}
const fn_err_no = () => {
    cy.xpath(elements.step10_fn_sbox_err_msg).should('not.exist')
    cy.get(elements.step10_fn_err_msg).should('not.exist')
}
const gn_err_no = () => {
    cy.xpath(elements.step10_gn_sbox_err_msg).should('not.exist')
    cy.get(elements.step10_gn_err_msg).should('not.exist')
}
const fn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step10_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step10_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
}
const gn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step10_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step10_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
}
//empty fields: [GN: empty, FN: empty]
export const your_details_name_step_10_v1 = () => {
    common.uam_tasklist_header()
    cy.get(elements.name).click().wait(Cypress.env('waitTime'))
    s10_page_heading()
    cy.get(elements.step10_gn_textbox).clear()
    cy.get(elements.step10_fn_textbox).clear()
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field valid: [GN: valid, FN: empty]
export const your_details_name_step_10_v2 = () => {
    s10_page_heading()
    cy.get(elements.step10_gn_err_textbox).type(secrets.given_names)
    click_continue()
    fn_err_yes()
    gn_err_no()
}
//one field valid: [GN: Empty, FN: Valid]
export const your_details_name_step_10_v3 = () => {
    s10_page_heading()
    cy.get(elements.step10_gn_textbox).clear()
    cy.get(elements.step10_fn_err_textbox).type(secrets.family_name)
    click_continue()
    gn_err_yes()
    fn_err_no()
}
//both fields invalid: [GN: invalid, FN: invalid]
export const your_details_name_step_10_v4 = () => {
    s10_page_heading()
    cy.get(elements.step10_gn_err_textbox).clear().type('1')
    cy.get(elements.step10_fn_textbox).clear().type('£')
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field valid: [GN: invalid, FN: valid]
export const your_details_name_step_10_v5 = () => {
    s10_page_heading()
    cy.get(elements.step10_gn_err_textbox).clear().type('+++++-')
    cy.get(elements.step10_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step10_gn_err_textbox).clear().type('123456')
    cy.get(elements.step10_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step10_gn_err_textbox).clear().type('bet4a')
    cy.get(elements.step10_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step10_gn_err_textbox).clear().type('.chali')
    cy.get(elements.step10_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step10_gn_err_textbox).clear().type('££$$**()')
    cy.get(elements.step10_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
}
//one field valid: [GN: valid, FN: invalid]
export const your_details_name_step_10_v6 = () => {
    s10_page_heading()
    cy.get(elements.step10_gn_err_textbox).clear().type(secrets.family_name)
    cy.get(elements.step10_fn_textbox).clear().type('+++++-')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step10_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step10_fn_err_textbox).clear().type('rome0')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step10_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step10_fn_err_textbox).clear().type('.hfu')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step10_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step10_fn_err_textbox).clear().type('Homes + Ukraine')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step10_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step10_fn_err_textbox).clear().type('$$$$££££')
    click_continue()
    fn_err_yes()
    gn_err_no()
}
//both fields valid: [GN: valid, FN: valid]
export const your_details_name_step_10_v7 = () => {
    cy.get(elements.step10_gn_textbox).clear().type(secrets.given_names)
    cy.get(elements.step10_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_no()
    cy.get(elements.page_heading).contains('Have you ever been known by another name?').should('be.visible')
    cy.get(elements.select_yes).click()
    click_continue()
}
//*******SPONSOR OTHER NAME**************SPONSOR OTHER NAME**************SPONSOR OTHER NAME**************SPONSOR OTHER NAME*******
const s12_page_heading = () => {
    cy.get(elements.page_heading).contains('Add your other name').should('be.visible')
}
const s12_fn_err_no = () => {
    cy.xpath(elements.step12_fn_sbox_err_msg).should('not.exist')
    cy.get(elements.step12_fn_err_msg).should('not.exist')
}
const s12_gn_err_no = () => {
    cy.xpath(elements.step12_gn_sbox_err_msg).should('not.exist')
    cy.get(elements.step12_gn_err_msg).should('not.exist')
}
const s12_fn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step12_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step12_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
}
const s12_gn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step12_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step12_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
}
//other name empty fields [GN: empty, FN: empty]
export const your_details_othername_step_12_v8 = () => {
    cy.visit('/sponsor-a-child/steps/12')
    cy.get(elements.page_heading).contains('Add your other name').should('be.visible')
    cy.get(elements.step12_gn_textbox).clear()
    cy.get(elements.step12_fn_textbox).clear()
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_yes()
}
//one field valid: [GN: valid, FN: empty]
export const your_details_othername_step_12_v9 = () => {
    s12_page_heading()
    cy.get(elements.step12_gn_err_textbox).clear().type(secrets.given_names)
    cy.get(elements.step12_fn_err_textbox).clear()
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
}
//one field valid: [GN: Empty, FN: Valid]
export const your_details_othername_step_12_v10 = () => {
    s12_page_heading()
    cy.get(elements.step12_gn_textbox).clear()
    cy.get(elements.step12_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_gn_err_yes()
    s12_fn_err_no()
}
//both fields invalid: [GN: invalid, FN: invalid]
export const your_details_othername_step_12_v11 = () => {
    s12_page_heading()
    cy.get(elements.step12_gn_err_textbox).clear().type('1')
    cy.get(elements.step12_fn_textbox).clear().type('£')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_yes()
}
//one field valid: [GN: invalid, FN: valid]
export const your_details_othername_step_12_v12 = () => {
    s12_page_heading()
    cy.get(elements.step12_gn_err_textbox).clear().type('++++-++++')
    cy.get(elements.step12_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_yes()
    cy.get(elements.step12_gn_err_textbox).clear().type('alf4A')
    cy.get(elements.step12_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_yes()
    cy.get(elements.step12_gn_err_textbox).clear().type('.bEta')
    cy.get(elements.step12_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_yes()
    cy.get(elements.step12_gn_err_textbox).clear().type('££££££^^^^^')
    cy.get(elements.step12_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_yes()
    cy.get(elements.step12_gn_err_textbox).clear().type('123456')
    cy.get(elements.step12_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_yes()
}
//one field valid: [GN: valid, FN: invalid]
export const your_details_othername_step_12_v13 = () => {
    s12_page_heading()
    cy.get(elements.step12_gn_err_textbox).clear().type(secrets.family_name)
    cy.get(elements.step12_fn_textbox).clear().type('++++-++++')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
    cy.get(elements.step12_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step12_fn_err_textbox).clear().type('chali.')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
    cy.get(elements.step12_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step12_fn_err_textbox).clear().type('tang0')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
    cy.get(elements.step12_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step12_fn_err_textbox).clear().type('@£$%^&*()')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
    cy.get(elements.step12_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step12_fn_err_textbox).clear().type('1111222233334444')
    click_continue()
    s12_fn_err_yes()
    s12_gn_err_no()
}
//both fields valid: [GN: valid, FN: valid]
export const your_details_othername_step_12_v14 = () => {
    cy.get(elements.step12_gn_textbox).clear().type(secrets.given_names)
    cy.get(elements.step12_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    s12_fn_err_no()
    s12_gn_err_no()
    cy.get(elements.page_heading).contains('You have added 1 other name').should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
}
//*******SPONSOR EMAIL**************SPONSOR EMAIL**************SPONSOR EMAIL**************SPONSOR EMAIL**************SPONSOR EMAIL*******
const email_heading = () => {
    cy.get(elements.page_heading).contains('Enter your email address').should('be.visible')
}
const email_not_valid_err = () => {
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_msg).should('be.visible')
    cy.get(elements.step14_email_err_msg).contains(bt_err.email_err_msg).should('be.visible')
}
const email_must_match_err = () => {
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
    cy.get(elements.step14_email_err_cf_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
}
//both feilds empty[email: empty, cf-email: empty]
export const your_details_contact_details_step_14_v1 = () => {
    cy.visit('/sponsor-a-child/task-list')
    cy.get(elements.contact_details_link).click()
    email_heading()
    cy.get(elements.step14_email_textbox).clear()
    cy.get(elements.step14_email_cf_textbox).clear()
    click_continue()
    email_not_valid_err()
}
//one field valid:[email: valid, cf-email: empty]
export const your_details_contact_details_step_14_v2 = () => {
    email_heading()
    cy.get(elements.step14_email_err_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_cf_textbox).clear()
    click_continue()
    email_must_match_err()
}
//one field valid:[email: empty, cf-email: valid]
export const your_details_contact_details_step_14_v3 = () => {
    email_heading()
    cy.get(elements.step14_email_textbox).clear()
    cy.get(elements.step14_email_err_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
}
//both fields invalid: [email: invalid, cf-email: invalid]
export const your_details_contact_details_step_14_v4 = () => {
    email_heading()
    cy.get(elements.step14_email_err_textbox).clear().type('t@')
    cy.get(elements.step14_email_cf_textbox).clear().type('zaizi.com')
    click_continue()
    email_not_valid_err()
}
//one field valid: [email: invalid, cf-email: valid]
export const your_details_contact_details_step_14_v5 = () => {
    email_heading()
    cy.get(elements.step14_email_err_textbox).clear().type('££!!&&')
    cy.get(elements.step14_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step14_email_err_textbox).clear().type('abc@.com')
    cy.get(elements.step14_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step14_email_err_textbox).clear().type('hfu@.com.')
    cy.get(elements.step14_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step14_email_err_textbox).clear().type('.hfu@hfucom')
    cy.get(elements.step14_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
}
//one field valid: [email: valid, cf-email: invalid]
export const your_details_contact_details_step_14_v6 = () => {
    email_heading()
    cy.get(elements.step14_email_err_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_cf_textbox).clear().type('123456')
    click_continue()
    email_must_match_err()
    cy.get(elements.step14_email_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_err_cf_textbox).clear().type('.'+secrets.email)
    click_continue()
    email_must_match_err()
    cy.get(elements.step14_email_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_err_cf_textbox).clear().type(secrets.email+'+')
    click_continue()
    email_must_match_err()
    cy.get(elements.step14_email_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_err_cf_textbox).clear().type('tperera+zaizi.com')
    click_continue()
    email_must_match_err()
}
//both fields valid: [email: valid, cf-email: valid]
export const your_details_contact_details_step_14_v7 = () => {
    email_heading()
    cy.get(elements.step14_email_textbox).clear().type(secrets.email)
    cy.get(elements.step14_email_err_cf_textbox).clear().type(secrets.email)
    click_continue()
    cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible')
}
//*******SPONSOR MOBILE**************SPONSOR MOBILE**************SPONSOR MOBILE**************SPONSOR MOBILE**************SPONSOR MOBILE*******
const phone_heading = () => {
    cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible')
}

const mobile_not_valid_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.mobile_err_msg).should('be.visible')
    cy.get(elements.step15_mob_err_msg).contains(bt_err.mobile_err_msg).should('be.visible')
}
const mobile_must_match_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
    cy.get(elements.step15_mob_err_cf_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
}
//both fields valid: [mobile: empty, cf-mobile: empty]
export const your_details_mobile_step_15_v1 = () => {
    cy.visit('/sponsor-a-child/steps/15')
    phone_heading()
    cy.get(elements.step15_mob_textbox).clear()
    cy.get(elements.step15_mob_cf_textbox).clear()
    click_continue()
    mobile_not_valid_err()
}
//one field valid:[mobile: valid, cf-mobile: empty]
export const your_details_mobile_step_15_v2 = () => {
    phone_heading()
    cy.get(elements.step15_mob_err_textbox).clear().type(secrets.mobile)
    cy.get(elements.step15_mob_cf_textbox).clear()
    click_continue()
    mobile_must_match_err()
}
//one field valid:[mobile: empty, cf-mobile: valid]
export const your_details_mobile_step_15_v3 = () => {
    phone_heading()
    cy.get(elements.step15_mob_textbox).clear()
    cy.get(elements.step15_mob_err_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    mobile_not_valid_err()
}
//both fields invalid: [mobile: invalid, cf-mobile: invalid]
export const your_details_mobile_step_15_v4 = () => {
    phone_heading()
    cy.get(elements.step15_mob_err_textbox).clear().type('075456789012')//12numbers
    cy.get(elements.step15_mob_cf_textbox).clear().type('0724567890')//10numbers 
    click_continue()
    mobile_not_valid_err()
    cy.get(elements.step15_mob_err_textbox).clear().type('0754567890')//10numbers 
    cy.get(elements.step15_mob_cf_textbox).clear().type('072456789012')//12numbers
    click_continue()
    mobile_not_valid_err()
    cy.get(elements.step15_mob_err_textbox).clear().type('07531')
    cy.get(elements.step15_mob_cf_textbox).clear().type('07531')
    click_continue()
    mobile_not_valid_err()
    cy.get(elements.step15_mob_err_textbox).clear().type('+4475123456788')//intl
    cy.get(elements.step15_mob_cf_textbox).clear().type('+4475123456788')
    click_continue()
    mobile_not_valid_err()
}
//one field valid: [mobile: invalid, cf-mobile: valid]
export const your_details_mobile_step_15_v5 = () => {
    phone_heading()
    cy.get(elements.step15_mob_err_textbox).clear().type('$7512345678')
    cy.get(elements.step15_mob_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    mobile_not_valid_err()
    cy.get(elements.step15_mob_err_textbox).clear().type('0751234567A')
    cy.get(elements.step15_mob_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    mobile_not_valid_err()
    cy.get(elements.step15_mob_err_textbox).clear().type('$$$$$$$$$$$')
    cy.get(elements.step15_mob_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    mobile_not_valid_err()
}
//one field valid: [mobile: valid, cf-mobile: invalid]
export const your_details_mobile_step_15_v6 = () => {
    phone_heading()
    cy.get(elements.step15_mob_err_textbox).clear().type(secrets.mobile)
    cy.get(elements.step15_mob_cf_textbox).clear() .type('$7512345678')
    click_continue()
    mobile_must_match_err()
    cy.get(elements.step15_mob_textbox).clear().type(secrets.mobile)
    cy.get(elements.step15_mob_err_cf_textbox).clear().type('0751234567A')
    click_continue()
    mobile_must_match_err()
    cy.get(elements.step15_mob_textbox).clear().type(secrets.mobile)
    cy.get(elements.step15_mob_err_cf_textbox).clear().type('$$$$$$$$$$$')
    click_continue()
    mobile_must_match_err()
}
//both fields valid: [mobile: valid, cf-mobile: valid]
export const your_details_mobile_step_15_v7 = () => {
    phone_heading()
    cy.get(elements.step15_mob_textbox).clear().type(secrets.mobile)
    cy.get(elements.step15_mob_err_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    cy.get(elements.page_heading).contains("Apply for approval to provide a safe home for a child from Ukraine").should('be.visible')
}
//*******ADDITIONAL DETAILS*********************ADDITIONAL DETAILS*********************ADDITIONAL DETAILS*********************ADDITIONAL DETAILS**************


export const your_details_adi_details_step_18_v1 = () => {
    cy.get(elements.additional_details).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Do you have any of these identity documents?').should('be.visible')
    click_continue()
    cy.get(elements.step16_id_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step16_idh_btn).click()
    click_continue()
}
export const your_details_prove_id_step_17 = () => {
    cy.get(elements.page_heading).contains('Can you prove your identity?').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.id_err_msg).should('be.visible')
    cy.get(elements.step17_id_reason_err_msg).contains(bt_err.id_err_msg).should('be.visible')
    cy.get(elements.step17_id_reason_err_textbox).type('PROVE YOUR IDENTITY')
    click_continue()
}
export const your_details_additional_details_step_18 = () => {
    cy.get(elements.page_heading).contains('Enter your date of birth').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step18_dob_err_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step18_day_err_textbox).type(secrets.day)
    cy.get(elements.step18_month_err_textbox).type(secrets.month)
    cy.get(elements.step18_year_err_textbox).type(secrets.year)
    click_continue()
}
export const your_details_additional_details_step_19 = () => {
    cy.get(elements.page_heading).contains('Enter your nationality').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.step19_nationality_err_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.step19_nationality_dropdown_err).select('GBR - United Kingdom').should('have.value', 'GBR - United Kingdom')
    click_continue()
}
export const your_details_additional_details_step_20 = () => {
    cy.get(elements.page_heading).contains('Have you ever held any other nationalities?').should('be.visible')
    click_continue()
    summery_box_error()
    cy.get(elements.step20_oth_nationality_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.other_nationalities_yes_radio_button).click()
    click_continue()
}
export const your_details_additional_details_step_21 = () => {
    cy.get(elements.page_heading).contains('Enter your other nationality').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.step21_oth_nationality_err_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.step21_oth_nationality_dropdown_err).select('GBD - British Overseas Territories').should('have.value', 'GBD - British Overseas Territories').wait(Cypress.env('waitTime'))
    click_continue()
}
export const your_details_additional_details_step_22 = () => {
    cy.get(elements.page_heading).contains('You have added 1 other nationality').should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
}