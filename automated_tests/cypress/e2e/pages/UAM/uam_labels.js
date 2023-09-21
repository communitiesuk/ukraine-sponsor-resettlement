require('cypress-xpath');
const secrets = require('../../../fixtures/uam_appdata.json')
const elements = require('../../page_elements/UAM/uam_elements')
const bodytext = require('../../../fixtures/uam_bodytext.json')
const common = require('./common')
const bt_err = require('../../../fixtures/uam_bodytext_err.json')

const summery_box_error = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.get(elements.err_sbox_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
}
const click_continue = () => {
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
const summary_box_title = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
}
export const uam_eligibility_start = () => {
    cy.visit('/sponsor-a-child/start')
    common.uam_start_header()
    cy.get(elements.startnow_button).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_check = () => {
    common.uam_check_header()
    cy.get(elements.page_body).contains(bodytext.check_eligibility_body).should('be.visible')
    cy.get(elements.continue_button_ec).click().wait(Cypress.env('waitTime'))
}
export const uam_eligibility_step_1 = () => {
    common.uam_step1_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step1_err_msg).should('be.visible')
    cy.get(elements.step1_err_radio_btn_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_2 = () => {
    common.uam_step2_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step2_err_msg).should('be.visible')
    cy.get(elements.step2_err_radio_btn_no).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_3 = () => {
    common.uam_step3_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step3_err_msg).should('be.visible')
    cy.get(elements.step3_err_radio_btn_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_4 = () => {
    common.uam_step4_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step4_err_msg).should('be.visible')
    cy.get(elements.step4_radio_btn_no).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_5 = () => {
    common.uam_step5_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step5_err_msg).should('be.visible')
    cy.get(elements.step5_err_radio_btn_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_6 = () => {
    common.uam_step6_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step6_err_msg).should('be.visible')
    cy.get(elements.step6_err_radio_btn_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_7 = () => {
    common.uam_step7_header()
    click_continue()
    summery_box_error()
    cy.get(elements.step7_err_msg).should('be.visible')
    cy.get(elements.step7_err_radio_btn_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const uam_eligibility_step_9 = () => {
    common.uam_step9_header()
    cy.get(elements.step9_start_application_btn).should('be.visible').click().wait(Cypress.env('waitTime'))
}
//APPLICATION STARTS HERE  
export const uam_eligibility_tasklist = () => {
    common.uam_tasklist_header()
}
//SPONSOR NAME
export const your_details_name_step_10 = () => {
    cy.get(elements.name).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your name').should('be.visible')
    click_continue()
    cy.xpath(elements.step10_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.xpath(elements.step10_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step10_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step10_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step10_gn_err_textbox).type(secrets.given_names)
    cy.get(elements.step10_fn_err_textbox).type(secrets.family_name).wait(Cypress.env('waitTime'))
    click_continue()
}
export const your_details_othername_step_11 = () => {
    cy.get(elements.page_heading).contains('Have you ever been known by another name?').should('be.visible')
    click_continue()
    summery_box_error()
    cy.get(elements.step11_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step11_err_yes).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const your_details_othername_step_12 = () => {
    cy.get(elements.page_heading).contains('Add your other name').should('be.visible')
    click_continue()
    cy.xpath(elements.step12_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.xpath(elements.step12_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step12_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step12_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step12_gn_err_textbox).type(secrets.known_by_given_names)
    cy.get(elements.step12_fn_err_textbox).type(secrets.known_by_family_name)
    click_continue()
}
export const your_details_othername_step_13 = () => {
    cy.get(elements.page_heading).contains('You have added 1 other name').should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.name_completed).should('be.visible')
}
export const your_details_contact_details_step_14 = () => {
    cy.get(elements.contact_details_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter your email address').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_msg).should('be.visible')
    cy.get(elements.step14_email_err_msg).contains(bt_err.email_err_msg).should('be.visible')
    cy.get(elements.step14_email_err_textbox).type(secrets.email)
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
    cy.get(elements.step14_email_err_cf_msg).contains(bt_err.email_err_mm_msg).should('be.visible')
    cy.get(elements.step14_email_err_cf_textbox).type(secrets.email).wait(Cypress.env('waitTime'))
    click_continue()
}
export const your_details_mobile_step_15 = () => {
    cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.mobile_err_msg).should('be.visible')
    cy.get(elements.step15_mob_err_msg).contains(bt_err.mobile_err_msg).should('be.visible')
    cy.get(elements.step15_mob_err_textbox).type(secrets.mobile).wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
    cy.get(elements.step15_mob_err_cf_msg).contains(bt_err.mobile_err_mm_msg).should('be.visible')
    cy.get(elements.step15_mob_err_cf_textbox).type(secrets.mobile).wait(Cypress.env('waitTime'))
    click_continue()
}
export const your_details_additional_details_step_16 = () => {
    cy.get(elements.additional_details).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Do you have any of these identity documents?').should('be.visible')
    click_continue()
    summery_box_error()
    cy.get(elements.step16_id_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step16_idh_btn).click().wait(Cypress.env('waitTime'))
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
    cy.get(elements.page_heading).contains('Enter your nationality').should('be.visible').wait(Cypress.env('waitTime'))
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
    cy.get(elements.step20_oth_nationality_err_yes).click().wait(Cypress.env('waitTime'))
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
export const childs_accommodation_step_23 = () => {
    // cy.visit('/sponsor-a-child/task-list')
    cy.get(elements.address_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Enter the address where the child will be living in the UK').should('be.visible')
    click_continue()
    summary_box_title()
    cy.xpath(elements.step23_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.xpath(elements.step23_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.xpath(elements.step23_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
    cy.get(elements.step23_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step23_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step23_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
//CLILD'S ADDRESS
    cy.get(elements.step23_addr_line1_err_textbox).type(secrets.child_line1)
    cy.get(elements.step23_addr_line2_err_textbox).type(secrets.child_line2)
    cy.get(elements.step23_city_err_textbox).type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).type(secrets.child_postcode).wait(Cypress.env('waitTime'))
    click_continue()
}
export const childs_accommodation_step_24 = () => {
    cy.get(elements.main_heading).contains('Will you (the sponsor) be living at this address?').should('be.visible')
    click_continue()
    summery_box_error()
    cy.get(elements.step24_sa_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step24_sa_err_no_btn).click().wait(Cypress.env('waitTime'))
    click_continue()
}
//SPONSOR ADDRESS
export const childs_accommodation_step_26 = () => {
    cy.get(elements.page_heading).contains('Enter the address where you will be living in the UK').should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.xpath(elements.step26_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.xpath(elements.step26_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.xpath(elements.step26_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
    cy.get(elements.step26_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step26_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step26_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
    cy.get(elements.step26_addr_line1_err_textbox).type(secrets.child_line1)
    cy.get(elements.step26_addr_line2_err_textbox).type(secrets.child_line2)
    cy.get(elements.step26_city_err_textbox).type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).type(secrets.child_postcode).wait(Cypress.env('waitTime'))
    click_continue()
}
export const childs_accommodation_step_27 = () => {
    //OVER 16 PERSON LIVING WITH THE CHILD
    cy.get(elements.page_heading).contains('Enter the name of a person over 16 who will live with the child').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.step27_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step27_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step27_gn_err_textbox).type(secrets.over16_name)
    cy.get(elements.step27_fn_err_textbox).type(secrets.over16_familyname)
    click_continue()
}
export const childs_accommodation_step_28 = () => {
    cy.get(elements.main_heading).contains('You have added 1 person over 16 who will live with the child').should('be.visible')
    cy.get(elements.residents_header).contains('Residents').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.over16_persons_name).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.add_another_person_button).contains('Add another person').should('be.visible')
    cy.get(elements.continue_button_other).click().wait(Cypress.env('waitTime'))
}
//RESIDENT'S DETAILS(OVER 16)
export const residents_details_step29 = () => {
    common.uam_tasklist_header()
    cy.xpath(elements.residents_details_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains("Enter this person's date of birth").should('be.visible')
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step29_dob_err_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step29_day_err_textbox).type(secrets.over16_day)
    cy.get(elements.step29_month_err_textbox).type(secrets.over16_month)
    cy.get(elements.step29_year_err_textbox).type(secrets.over16_year)
    click_continue()
}
export const residents_details_step30 = () => {
    cy.get(elements.page_heading).contains('Enter their nationality').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.step30_nat_err_msg).contains(bt_err.nationality_err_msg).should('be.visible')
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    cy.get(elements.step30_nat_err_dd).select('ZWE - Zimbabwe').should('have.value', 'ZWE - Zimbabwe').wait(Cypress.env('waitTime'))
    click_continue()
}
export const residents_details_step31 = () => {
    cy.get(elements.page_heading).contains('Do they have any of these identity documents?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.residents_details_inserttext).should('contain.text', 'OVER SIXTEEN').should('be.visible')
    click_continue()
    summery_box_error()
    cy.get(elements.step31_id_err_msg).contains(bt_err.sel_opt_err_msg).should('be.visible')
    cy.get(elements.step31_pp_err_radio_btn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step31_pp_textbox).should('be.visible').type(secrets.over16_passport_no).wait(Cypress.env('waitTime'))
    click_continue()
}
export const childs_details_step_32 = () => {
    cy.visit('/sponsor-a-child/task-list')
    cy.get(elements.childs_personal_details_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains("Enter the name of the child you want to sponsor").should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.xpath(elements.step32_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.xpath(elements.step32_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.step32_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step32_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.step32_gn_err_textbox).should('be.visible').type(secrets.child_name)
    cy.get(elements.step32_fn_err_textbox).should('be.visible').type(secrets.child_familyname).wait(Cypress.env('waitTime'))
    click_continue()
}
export const childs_details_step_33 = () => {
    cy.get(elements.main_heading).contains("How can we contact the child?").should('be.visible')
    cy.get(elements.childs_personal_details_insettext).contains("TINY BOB").should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.sel_more_opt_err_msg).should('be.visible')
    cy.get(elements.step33_ctc_err_msg).contains(bt_err.sel_more_opt_err_msg).should('be.visible')
    cy.get(elements.step33_email_err_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step33_email_textbox).type(secrets.child_email)
    cy.get(elements.step33_email_cf_textbox).type(secrets.child_email)
    cy.get(elements.step33_phone_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step33_phone_textbox).type(secrets.child_phone_no)
    cy.get(elements.step33_phone_cf_textbox).type(secrets.child_phone_no).wait(Cypress.env('waitTime'))
    click_continue()
}
export const childs_details_step_34 = () => {
    cy.get(elements.main_heading).contains("Enter their date of birth").should('be.visible')
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step34_dob_err_msg).contains(bt_err.dob_err_msg).should('be.visible')
    cy.get(elements.step34_day_err_textbox).type(secrets.child_day)
    cy.get(elements.step34_month_err_textbox).type(secrets.child_month)
    cy.get(elements.step34_year_err_textbox).type(secrets.child_year)
    click_continue()
}
export const consent_form_step_35 = () => {
    cy.get(elements.consentform_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains('You must upload 2 completed parental consent forms').should('be.visible').wait(Cypress.env('waitTime'))
    click_continue()
}
export const consent_form_step_36 = () => {
    cy.get(elements.page_heading_xl).contains('Upload the UK sponsorship arrangement consent form').should('be.visible')
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.cfile_err_msg).should('be.visible')
    cy.get(elements.step36_uk_form_err_msg).contains(bt_err.cfile_err_msg).should('be.visible')
    cy.get(elements.step36_cfile_err_btn).attachFile("jpegs/saconsent.png").wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.consentform_completed_tag).should('be.visible').wait(Cypress.env('waitTime'))
}
export const ukrconsent_form_step_37 = () => {
    cy.get(elements.ukrconsentform_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.insettext).contains("TINY BOB").should('be.visible')
    cy.get(elements.page_heading_xl).contains('Upload the Ukraine certified consent form').should('be.visible')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.cfile_err_msg).should('be.visible')
    cy.get(elements.step37_ukr_form_err_msg).contains(bt_err.cfile_err_msg).should('be.visible')
    cy.get(elements.step37_cfile_err_btn).attachFile("jpegs/ukrconsent.png").wait(Cypress.env('waitTime'))
    click_continue()
    cy.xpath(elements.ukrconsentform_completed_tag).should('be.visible').wait(Cypress.env('waitTime'))
}
export const confirmation_page_step_38 = () => {
    common.uam_tasklist_header()
    cy.get(elements.confirm_data_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Confirm you have read the privacy statement').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.privacy_err_msg).should('be.visible')
    cy.get(elements.step38_privacy_err_msg).contains(bt_err.privacy_err_msg).should('be.visible')
    cy.get(elements.step38_privacy_err_checkbox).click().wait(Cypress.env('waitTime'))
    click_continue()
}
export const confirmation_page_step_39 = () => {
    common.uam_tasklist_header()
    cy.get(elements.confirm_eligibility_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading_xl).contains('Confirm your eligibility to sponsor a child from Ukraine').should('be.visible')
    click_continue()
    summary_box_title()
    cy.get(elements.err_sbox_msg).contains(bt_err.chk_the_box_err_msg).should('be.visible')
    cy.get(elements.step39_ctb_err_msg).contains(bt_err.chk_the_box_err_msg).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.step39_ctb_err_checkbox).click().wait(Cypress.env('waitTime'))
    click_continue()
}
//CHECK ANSWERS
export const check_answers = () => {
    common.uam_tasklist_header()
    cy.get(elements.check_your_answers_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Check your answers before sending your application').should('be.visible')
    cy.xpath(elements.answers_fullname).contains(secrets.full_name)
    cy.get(elements.answers_othernames).contains(secrets.known_by_fullname)
    cy.get(elements.answers_email).contains(secrets.email)
    cy.get(elements.answers_mobile).contains(secrets.mobile)
    cy.get(elements.answers_id).contains('none')
    cy.get(elements.answers_dob).contains(secrets.dob)
    cy.get(elements.answers_nationality).contains("GBR - United Kingdom")
    cy.get(elements.answers_other_nationalities).contains("GBD - British Overseas Territories").wait(Cypress.env('waitTime'))
    cy.get(elements.answers_child_address).contains(secrets.clild_address)
    cy.get(elements.answers_over16_name).contains(secrets.over16_fullname)
    cy.get(elements.answers_child_fullname).contains(secrets.child_fullname)
    cy.get(elements.answers_child_email).contains(secrets.child_email)
    cy.get(elements.answers_child_phone).contains(secrets.child_phone_no)
    cy.get(elements.answers_child_dob).contains(secrets.child_dob)
    cy.get(elements.answers_consent1).contains('saconsent.png')
    cy.get(elements.answers_consent2).contains('ukrconsent.png')
    cy.get(elements.answers_agree1).contains('Agreed')
    cy.get(elements.answers_agree2).contains('Agreed').wait(Cypress.env('waitTime'))
}
