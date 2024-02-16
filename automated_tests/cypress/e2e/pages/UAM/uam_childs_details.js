require('cypress-xpath');
const secrets = require('../../../fixtures/uam_appdata.json')
const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
const common = require('./common')
const bt_err = require('../../../fixtures/uam_bodytext_err.json')
import dayjs from 'dayjs'

//*******Child's Name**************Child's Name**************Child's Name**************Child's Name**************Child's Name*******
const click_continue = () => {
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const s32_page_heading = () => {
    cy.get(elements.page_heading).contains('Enter the name of the child you want to sponsor').should('be.visible')
}
const fn_err_no = () => {
    cy.xpath(elements.step32_fn_sbox_err_msg).should('not.exist')
    cy.get(elements.step32_fn_err_msg).should('not.exist')
}
const gn_err_no = () => {
    cy.xpath(elements.step32_gn_sbox_err_msg).should('not.exist')
    cy.get(elements.step32_gn_err_msg).should('not.exist')
}
const fn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step32_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step32_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
}
const gn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step32_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step32_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
}
//empty fields: [GN: empty, FN: empty]
export const childs_details_step_32_v1 = () => {
    cy.visit('/sponsor-a-child/steps/32')
    s32_page_heading()
    cy.get(elements.step32_gn_textbox).clear()
    cy.get(elements.step32_fn_textbox).clear()
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field empty: 
export const childs_details_step_32_v2 = () => {
    //[GN: valid, FN: empty]
    s32_page_heading()
    cy.get(elements.step32_gn_err_textbox).clear().type(secrets.given_names)
    cy.get(elements.step32_fn_err_textbox).clear()
    click_continue()
    fn_err_yes()
    gn_err_no()
}
export const childs_details_step_32_v3 = () => {
    //[GN: Empty, FN: Valid]
    s32_page_heading()
    cy.get(elements.step32_gn_textbox).clear()
    cy.get(elements.step32_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    gn_err_yes()
    fn_err_no()
}
//both fields invalid: [GN: invalid, FN: invalid]
export const childs_details_step_32_v4 = () => {
    s32_page_heading()
    cy.get(elements.step32_gn_err_textbox).clear().type('1')
    cy.get(elements.step32_fn_textbox).clear().type('£')
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field valid: [GN: invalid, FN: valid]
export const childs_details_step_32_v5 = () => {
    s32_page_heading()
    cy.get(elements.step32_gn_err_textbox).clear().type('+++++-')
    cy.get(elements.step32_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step32_gn_err_textbox).clear().type('123456')
    cy.get(elements.step32_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step32_gn_err_textbox).clear().type('bet4a')
    cy.get(elements.step32_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step32_gn_err_textbox).clear().type('.chali')
    cy.get(elements.step32_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step32_gn_err_textbox).clear().type('££$$**()')
    cy.get(elements.step32_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
}
//one field valid: [GN: valid, FN: invalid]
export const childs_details_step_32_v6 = () => {
    s32_page_heading()
    cy.get(elements.step32_gn_err_textbox).clear().type(secrets.family_name)
    cy.get(elements.step32_fn_textbox).clear().type('+++++-')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step32_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step32_fn_err_textbox).clear().type('rome0')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step32_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step32_fn_err_textbox).clear().type('.hfu')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step32_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step32_fn_err_textbox).clear().type('Homes + Ukraine')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step32_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step32_fn_err_textbox).clear().type('$$$$££££')
    click_continue()
    fn_err_yes()
    gn_err_no()
}
//both fields valid: [GN: valid, FN: valid]
export const childs_details_step_32_v7 = () => {
    cy.get(elements.step32_gn_textbox).clear().type(secrets.given_names)
    cy.get(elements.step32_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_no()
    cy.get(elements.page_heading).contains('How can we contact the child?').should('be.visible')
}

//*******Childs Email**************Childs Email**************Childs Email**************Childs Email**************Childs Email*******
const contact_type_heading = () => {
    cy.get(elements.page_heading).contains('How can we contact the child?').should('be.visible')
}
const email_not_valid_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_msg).should('be.visible')
    cy.get(elements.step33_email_err_msg).contains(bt_err.email_err_msg).should('be.visible')
}
const email_must_match_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
    cy.get(elements.step33_email_err_cf_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
}
const ctc_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.sel_more_opt_err_msg).should('be.visible')
    cy.get(elements.step33_ctc_err_msg).contains(bt_err.sel_more_opt_err_msg).should('be.visible')
}
//both fields empty[email: empty, cf-email: empty]
export const childs_details_step_33_v1 = () => {
    cy.visit('/sponsor-a-child/steps/33')
    contact_type_heading()
    click_continue()
    ctc_err()
    cy.get(elements.step33_email_err_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step33_email_textbox).clear()
    cy.get(elements.step33_email_cf_textbox).clear()
    click_continue()
    email_not_valid_err()
}
//one field valid:[email: valid, cf-email: empty]
export const childs_details_step_33_v2 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_err_textbox).clear().type(secrets.child_email)
    cy.get(elements.step33_email_cf_textbox).clear()
    click_continue()
    email_must_match_err()
}
//one field valid:[email: empty, cf-email: valid]
export const childs_details_step_33_v3 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_textbox).clear()
    cy.get(elements.step33_email_err_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
}
//both fields invalid: [email: invalid, cf-email: invalid]
export const childs_details_step_33_v4 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_err_textbox).clear().type('t@')
    cy.get(elements.step33_email_cf_textbox).clear().type('zaizi.com')
    click_continue()
    email_not_valid_err()
}
//one field valid: [email: invalid, cf-email: valid]
export const childs_details_step_33_v5 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_err_textbox).clear().type('££!!&&')
    cy.get(elements.step33_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step33_email_err_textbox).clear().type('abc@.com')
    cy.get(elements.step33_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step33_email_err_textbox).clear().type('hfu@.com.')
    cy.get(elements.step33_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
    cy.get(elements.step33_email_err_textbox).clear().type('.hfu@hfucom')
    cy.get(elements.step33_email_cf_textbox).clear().type(secrets.email)
    click_continue()
    email_not_valid_err()
}
//one field valid: [email: valid, cf-email: invalid]
export const childs_details_step_33_v6 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_err_textbox).clear().type(secrets.email)
    cy.get(elements.step33_email_cf_textbox).clear().type('123456')
    click_continue()
    email_must_match_err()
    cy.get(elements.step33_email_textbox).clear().type(secrets.email)
    cy.get(elements.step33_email_err_cf_textbox).clear().type('.'+secrets.email)
    click_continue()
    email_must_match_err()
    cy.get(elements.step33_email_textbox).clear().type(secrets.email)
    cy.get(elements.step33_email_err_cf_textbox).clear().type(secrets.email+'+')
    click_continue()
    email_must_match_err()
    cy.get(elements.step33_email_textbox).clear().type(secrets.email)
    cy.get(elements.step33_email_err_cf_textbox).clear().type('tperera+zaizi.com')
    click_continue()
    email_must_match_err()
}
//both fields valid: [email: valid, cf-email: valid]
export const childs_details_step_33_v7 = () => {
    contact_type_heading()
    cy.get(elements.step33_email_textbox).clear().type(secrets.email)
    cy.get(elements.step33_email_err_cf_textbox).clear().type(secrets.email)
    click_continue()
    cy.get(elements.page_heading).contains('Enter their date of birth').should('be.visible').wait(Cypress.env('waitTime'))
}
//*******Child's Mobile**************Child's Mobile**************Child's Mobile**************Child's Mobile**************Child's Mobile*******
const phone_not_valid_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.phone_err_msg).should('be.visible')
    cy.get(elements.step33_phone_err_msg).contains(bt_err.phone_err_msg).should('be.visible')
}
const phone_must_match_err = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
    cy.get(elements.step33_phone_err_cf_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
}
//both fields empty: [phone: empty, cf-phone: empty]
export const childs_details_step_33_v8 = () => {
    cy.visit('/sponsor-a-child/steps/33')
    contact_type_heading()
    cy.get(elements.step33_phone_checkbox).uncheck().click()
    cy.get(elements.step33_phone_textbox).clear()
    cy.get(elements.step33_phone_cf_textbox).clear()
    click_continue()
    phone_not_valid_err()
}
//one field empty:[phone: valid, cf-phone: empty]
export const childs_details_step_33_v9 = () => {
    contact_type_heading()
    cy.get(elements.step33_phone_err_textbox).clear().type(secrets.mobile)
    cy.get(elements.step33_phone_cf_textbox).clear()
    click_continue()
    phone_must_match_err()
}
//one field valid:[phone: empty, cf-phone: valid]
export const childs_details_step_33_v10 = () => {
    contact_type_heading()
    cy.get(elements.step33_phone_textbox).clear()
    cy.get(elements.step33_phone_err_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    phone_not_valid_err()
}
//both fields invalid: [phone: invalid, cf-phone: invalid]
export const childs_details_step_33_v11 = () => {
    contact_type_heading()
    cy.get(elements.step33_phone_err_textbox).clear().type('075456789012123')//12numbers
    cy.get(elements.step33_phone_cf_textbox).clear().type('0724567890')//10numbers 
    click_continue()
    phone_not_valid_err()
    cy.get(elements.step33_phone_err_textbox).clear().type('0754567890')//10numbers 
    cy.get(elements.step33_phone_cf_textbox).clear().type('072456789012')//12numbers
    click_continue()
    phone_not_valid_err()
    cy.get(elements.step33_phone_err_textbox).clear().type('07531')
    cy.get(elements.step33_phone_cf_textbox).clear().type('07531')
    click_continue()
    phone_not_valid_err()
    cy.get(elements.step33_phone_err_textbox).clear().type('+44751234567888')//intl
    cy.get(elements.step33_phone_cf_textbox).clear().type('+44751234567888')
    click_continue()
    phone_not_valid_err()
}
//one field valid: [phone: invalid, cf-phone: valid]
export const childs_details_step_33_v12 = () => {
    contact_type_heading()
    cy.get(elements.step33_phone_err_textbox).clear().type('$7512345678')
    cy.get(elements.step33_phone_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    phone_not_valid_err()
    cy.get(elements.step33_phone_err_textbox).clear().type('0751234567A')
    cy.get(elements.step33_phone_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    phone_not_valid_err()
    cy.get(elements.step33_phone_err_textbox).clear().type('$$$$$$$$$$$')
    cy.get(elements.step33_phone_cf_textbox).clear().type(secrets.mobile)
    click_continue()
    phone_not_valid_err()
}
//one field valid: [phone: valid, cf-phone: invalid]
export const childs_details_step_33_v13 = () => {
    contact_type_heading()
    cy.get(elements.step33_phone_err_textbox).clear().type(secrets.mobile)
    cy.get(elements.step33_phone_cf_textbox).clear() .type('$7512345678')
    click_continue()
    phone_must_match_err()
    cy.get(elements.step33_phone_textbox).clear().type(secrets.mobile)
    cy.get(elements.step33_phone_err_cf_textbox).clear().type('0751234567A')
    click_continue()
    phone_must_match_err()
    cy.get(elements.step33_phone_textbox).clear().type(secrets.mobile)
    cy.get(elements.step33_phone_err_cf_textbox).clear().type('$$$$$$$$$$$')
    click_continue()
    phone_must_match_err()
}
//they cannot be contacted
export const childs_details_step_33_v14 = () => {
    contact_type_heading()
    cy.get(elements.step33_ctc_checkbox).click()
    click_continue()
    cy.get(elements.page_heading).contains("Enter their date of birth").should('be.visible')
}
//*******Child's DOB**************Child's DOB**************Child's DOB**************Child's DOB****************************Child's DOB**************
const s34_page_heading = () => {cy.get(elements.page_heading).contains("Enter their date of birth").should('be.visible')}
const dob_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step34_dob_err_msg).contains(bt_err.dob_err_msg).should('be.visible')
}
const dob_u18_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_u18_err_msg).should('be.visible')
    cy.get(elements.step34_dob_err_msg).contains(bt_err.dob_u18_err_msg).should('be.visible')
}
const dob_future_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_future_date_err_msg).should('be.visible')
    cy.get(elements.step34_dob_err_msg).contains(bt_err.dob_future_date_err_msg).should('be.visible')
}

//all fields empty: [D: empty, M: empty, Year: empty]
export const childs_details_step_34_v1 = () => {
    cy.visit('/sponsor-a-child/steps/34')
    cy.get(elements.main_heading).contains("Enter their date of birth").should('be.visible')
    s34_page_heading()
    click_continue()
    dob_err_yes()
    click_continue()
}
//two fields empty: 
export const childs_details_step_34_v2 = () => {
    cy.get(elements.step34_day_err_textbox).type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear()
    cy.get(elements.step34_year_err_textbox).clear()
    click_continue()
    s34_page_heading
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear()
    cy.get(elements.step34_month_err_textbox).type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear()
    click_continue()
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear()
    cy.get(elements.step34_month_err_textbox).clear()
    cy.get(elements.step34_year_err_textbox).type(secrets.year)
    click_continue()
    dob_err_yes()
}
//one field empty: 
export const childs_details_step_34_v3 = () => {
    cy.get(elements.step34_day_err_textbox).clear()
    cy.get(elements.step34_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear().type(secrets.year)
    click_continue()
    s34_page_heading
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear()
    cy.get(elements.step34_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear()
    click_continue()
    dob_err_yes()
}
//one field valid: 
export const childs_details_step_34_v4 = () => {
    cy.get(elements.step34_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear().type('x')
    cy.get(elements.step34_year_err_textbox).clear().type('y')
    click_continue()
    s34_page_heading
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type('z')
    cy.get(elements.step34_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear().type('£')
    click_continue()
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type('$')
    cy.get(elements.step34_month_err_textbox).clear().type('@')
    cy.get(elements.step34_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
}
//two fields valid: 
export const childs_details_step_34_v5 = () => {
    cy.get(elements.step34_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear().type('100')
    click_continue()
    s34_page_heading
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type('32')
    cy.get(elements.step34_month_err_textbox).clear().type(secrets.month)
    cy.get(elements.step34_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
    cy.get(elements.step34_day_err_textbox).clear().type(secrets.day)
    cy.get(elements.step34_month_err_textbox).clear().type('14')
    cy.get(elements.step34_year_err_textbox).clear().type(secrets.year)
    click_continue()
    dob_err_yes()
}
const day = dayjs().add(0, 'day').format('DD')
const month = dayjs().add(0, 'month').format('MM')
const year = dayjs().add(0, 'year').format('YYYY')
const year_p_1 = dayjs().add(+1, 'year').format('YYYY')
const day_p_1 = dayjs().add(+1, 'day').format('DD')
const year_m_18 = dayjs().add(-18, 'year').format('YYYY')
const year_m_19 = dayjs().add(-19, 'year').format('YYYY')
const year_m_17 = dayjs().add(-17, 'year').format('YYYY')
//all valid: future date [next year]
export const childs_details_step_34_v6 = (x) => {
    cy.get(elements.step34_day_err_textbox).clear().type(day)
    cy.get(elements.step34_month_err_textbox).clear().type(month)
    cy.get(elements.step34_year_err_textbox).clear().type(year_p_1)
    click_continue()
    s34_page_heading
    dob_future_err_yes()
}
//all valid: future date [tomorrrow]
export const childs_details_step_34_v7 = (x) => {
    cy.get(elements.step34_day_err_textbox).clear().type(day_p_1)
    cy.get(elements.step34_month_err_textbox).clear().type(month)
    cy.get(elements.step34_year_err_textbox).clear().type(year)
    click_continue()
    s34_page_heading
    dob_future_err_yes()
}
 //all valid: past date [19 years old]  
export const childs_details_step_34_v8 = () => {
    cy.get(elements.step34_day_err_textbox).clear().type(day)
    cy.get(elements.step34_month_err_textbox).clear().type(month)
    cy.get(elements.step34_year_err_textbox).clear().type(year_m_19)
    click_continue()
    s34_page_heading
    dob_u18_err_yes()
}
//all valid: past date [18 years old]  
export const childs_details_step_34_v9 = () => {
    cy.get(elements.step34_day_err_textbox).clear().type(day)
    cy.get(elements.step34_month_err_textbox).clear().type(month)
    cy.get(elements.step34_year_err_textbox).clear().type(year_m_18)
    click_continue()
    s34_page_heading
    dob_u18_err_yes()
}
//all valid: past date [17 year old]  
export const childs_details_step_34_v10 = () => {
    cy.get(elements.step34_day_err_textbox).clear().type(day)
    cy.get(elements.step34_month_err_textbox).clear().type(month)
    cy.get(elements.step34_year_err_textbox).clear().type(year_m_17)
    click_continue()
    cy.get(elements.page_heading).contains('Apply for approval to provide a safe home for a child from Ukraine').should('be.visible')
}