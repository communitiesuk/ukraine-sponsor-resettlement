require('cypress-xpath');
const elements = require('../../page_elements/UAM/uam_elements')
const eligibility = require('../../pages/UAM/eligibility')
//const bodytext = require('../../../fixtures/uam_bodytext.json')
const secrets = require('../../../fixtures/uam_appdata.json')
const common = require('./common')

const show_hide = () => {
    cy.visit('/sponsor-a-child/')
    cy.get('body').then(($body) => {
        if ($body.find(elements.show_true).length > 0) { //evaluates as show if button exists at all
            cy.get(elements.show_true).should('be.visible')
            cy.log('aria expanded = Yes')
        }
        else if ($body.find(elements.show_false).length > 0) { //evaluates as show if button exists at all
            cy.get(elements.show_false).click().wait(Cypress.env('waitTime'))
            cy.log('aria expanded = No')
        }
    })
}
const link1 = "https://www.gov.uk/guidance/homes-for-ukraine-guidance-for-sponsors-children-and-minors-applying-without-parents-or-legal-guardians"
const link2 = "https://www.gov.uk/guidance/homes-for-ukraine-guidance-for-sponsors-children-and-minors-applying-without-parents-or-legal-guardians#parent-or-legal-guardian-consent"
const link3 = "https://www.gov.uk/government/publications/homes-for-ukraine-uk-sponsorship-arrangement-consent-form"
const link4 = "https://www.gov.uk/guidance/apply-for-a-visa-under-the-ukraine-sponsorship-scheme#applicants-aged-under-18"
const link5 = "https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/"
const link6 = "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/"
const link7 = "https://www.gov.uk/guidance/apply-for-a-ukraine-family-scheme-visa"
const link8 = "https://www.gov.uk/guidance/apply-for-a-visa-under-the-ukraine-sponsorship-scheme"
const link9 = "https://www.gov.uk/guidance/homes-for-ukraine-guidance-for-parents-or-legal-guardians-children-and-minors-applying-without-parents#parental-or-legal-guardian-consent-1"
const link10 = "https://www.gov.uk/guidance/homes-for-ukraine-visa-sponsorship-scheme-privacy-notice"
const link11 = "https://www.gov.uk/register-interest-homes-ukraine"
const main_p_heading = () =>{cy.get(elements.page_heading).contains('Apply to provide a safe home for a child from Ukraine').should('be.visible')}
const guidance_for_sponsoring_a_child_link = () =>{
    cy.xpath(elements.mainp_gui_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link1).should('exist')
    cy.get(elements.page_heading_cont).contains('Guidance').should('be.visible')
    cy.go('back')
}
const uk_spon_arr_consent_form_link = () =>{
    cy.xpath(elements.spon_consent_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link3).should('exist')
    cy.get(elements.page_heading_cont).contains('Form').should('be.visible')
    cy.go('back')
}
//TEST STEPS START HERE
export const uam_main_page_guidance = () => {
    cy.visit('/sponsor-a-child/')
    main_p_heading()
    guidance_for_sponsoring_a_child_link()
}
export const uam_main_spon_consent = () => {
    show_hide() //click accordion to show all
    main_p_heading()
    uk_spon_arr_consent_form_link()
}
export const uam_main_fo_comp_consent = () => {
    main_p_heading()
    cy.xpath(elements.how_to_comp_consent_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link2).should('exist')
    cy.get(elements.page_heading_cont).contains('Guidance').should('be.visible')
    cy.go('back')
}
export const uam_main_gui_apply_visa = () => {
    main_p_heading()
    cy.xpath(elements.apply_visa).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link4).should('exist')
    cy.get(elements.page_heading_cont).contains('Guidance').should('be.visible')
    cy.go('back')
}
export const uam_gov_lic = () => {
    main_p_heading()
    cy.xpath(elements.gov_lic_link).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link6).should('exist')
    cy.get(elements.open_lic_logo).should('be.visible')
    cy.go('back')
}
export const uam_crown_copyright = () => {
    main_p_heading()
    cy.get(elements.crown_cr).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link5).should('exist')
    cy.get(elements.crown_cr_header).contains('Crown copyright').should('be.visible')
    cy.go('back')
}
export const uam_main_page_apply = () => {
    main_p_heading()
    cy.get(elements.spchild_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.startnow_button).should('be.visible')
    cy.go('back')
}
//start page
export const uam_start_page_cont = () => {
    cy.visit('/sponsor-a-child/start')
    common.uam_start_header()
    cy.xpath(elements.cont_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Request a secure link to your application')
    cy.url().should('include', '/sponsor-a-child/save-and-return/resend-link').should('exist')
}
export const uam_start_page_newapp = () => {
    cy.xpath(elements.start_new_app).click().wait(Cypress.env('waitTime'))
    common.uam_start_header()
}
export const uam_start_page_guidance = () => {
    cy.visit('/sponsor-a-child/start')
    common.uam_start_header()
    guidance_for_sponsoring_a_child_link()
}
export const uam_start_page_spon_consent = () => {
    common.uam_start_header()
    uk_spon_arr_consent_form_link()
}
//cannot use this service
const cannot_uts_heading = () => {cy.get(elements.main_heading).contains('You cannot use this service').should('be.visible') }
export const uam_cannot_uts_prev = () => {
    eligibility.uam_eligibility_start()
    cy.get(elements.continue_button_ec).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step1_radio_btn_no).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('You cannot use this service')
    cy.xpath(elements.go_back_pre_page).click().wait(Cypress.env('waitTime'))
    common.uam_step1_header()
}
export const uam_cannot_uts_spon_fam = () => {
    cy.visit('/sponsor-a-child/non-eligible')
    cannot_uts_heading()
    cy.xpath(elements.spon_fam_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains('Apply for a Ukraine Family Scheme visa').should('be.visible')
    cy.url().should('include', link7).should('exist')
    cy.go('back')
}
export const uam_cannot_uts_spon_alknow = () => {
    cy.visit('/sponsor-a-child/non-eligible')
    cannot_uts_heading()
    cy.xpath(elements.spon_alknow_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.get(elements.main_heading).contains('Apply for a visa under the Ukraine Sponsorship Scheme (Homes for Ukraine)').should('be.visible')
    cy.url().should('include', link8).should('exist')
    cy.go('back')
}
export const uam_cannot_uts_register = () => {
    cy.visit('/sponsor-a-child/non-eligible')
    cannot_uts_heading()
    cy.xpath(elements.register_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading_xl).contains('Homes for Ukraine: record your interest').should('be.visible')
    cy.url().should('include', link11).should('exist')
    cy.go('back')
}
export const uam_step_5 = () => {
    eligibility.uam_eligibility_start()
    cy.visit('/sponsor-a-child/steps/5')
    common.uam_step5_header()
    cy.xpath(elements.step5_guidance_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link2).should('exist')
    cy.get(elements.page_heading_cont).contains('Guidance').should('be.visible')
    cy.go('back')
}
const mim_period = () =>{
    cy.get(elements.summary_text).click().contains('What is the minimum period?').should('be.visible')
    cy.get(elements.details_text).click().contains('You must commit to hosting the child in the UK for at least').should('be.visible')}
export const uam_step_6 = () => {
    cy.visit('/sponsor-a-child/steps/6')
    common.uam_step6_header()
    mim_period()
    cy.visit('/sponsor-a-child/steps/7')
    mim_period()
}
const Continue = () => {cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))}
const email = () => {
    cy.get(elements.page_heading).contains('Enter your email address').should('be.visible')
    cy.get(elements.step14_email_textbox).type(secrets.email)
    cy.get(elements.step14_email_cf_textbox).type(secrets.email)
}
const mobile = () => {
    cy.get(elements.page_heading).contains('Enter your UK mobile number').should('be.visible')
    cy.get(elements.step15_mob_textbox).type(secrets.mobile)
    cy.get(elements.step15_mob_cf_textbox).type(secrets.mobile)
}
const i_am_not_sure_link = () =>{
    cy.get(elements.summary_text).click().contains("I'm not sure how to enter my name").should('be.visible')
    cy.get(elements.details_text).click().contains('Enter your name as it is written on your identity documents.').should('be.visible')
}
export const uam_step_10_l1 = () => {
    cy.visit('/sponsor-a-child/steps/10')
    common.uam_step10_header()
    i_am_not_sure_link()
}
export const uam_step_10_l2 = () => {
    cy.visit('/sponsor-a-child/steps/10')
    common.uam_step10_header()
    cy.xpath(elements.save_return).click().wait(Cypress.env('waitTime'))
    email()
    cy.xpath(elements.save_return).click().wait(Cypress.env('waitTime')) //save and return will clear the email text feilds
    email()
    Continue()
    mobile()
    cy.xpath(elements.save_return).click().wait(Cypress.env('waitTime'))//save and return will clear the email text feilds
    mobile()
    Continue()
    cy.get(elements.page_heading).contains("We've sent you an email with a link to your saved application").should('be.visible')
    cy.xpath(elements.email_sent_cf).contains("We've sent the link to t******@zaizi.com.").should('be.visible')
}
const other_name1 = () =>{
    cy.get(elements.step12_gn_textbox).clear().type(secrets.known_by_given_names)
    cy.get(elements.step12_fn_textbox).clear().type(secrets.known_by_family_name)
}
const other_name2 = () =>{
    cy.get(elements.step12_gn_textbox).clear().type("OTHER")
    cy.get(elements.step12_fn_textbox).clear().type("NAME")
}
export const uam_step_12 = () => {
    cy.visit('/sponsor-a-child/steps/12').wait(Cypress.env('waitTime'))
    common.uam_step12_header()
    i_am_not_sure_link()
    other_name1()
    Continue()
}
export const uam_step_13 = () => {
    common.uam_step13_header()
    cy.get(elements.add_btn).contains('Add another name').click().wait(Cypress.env('waitTime'))
    other_name2()
    Continue()
    cy.xpath(elements.remove_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step_13_otr_name).should('not.exist')
}
export const uam_step_22 = () => {
    cy.visit('/sponsor-a-child/steps/21').wait(Cypress.env('waitTime'))
    common.uam_step21_header()
    cy.get(elements.other_nationality_dropdown).select('GBD - British Overseas Territories').wait(Cypress.env('waitTime'))
    Continue()
    cy.get(elements.add_btn).contains('Add another nationality').click().wait(Cypress.env('waitTime'))
    cy.get(elements.other_nationality_dropdown).select('USA - United States').wait(Cypress.env('waitTime'))
    Continue()
    cy.xpath(elements.remove_link).click().wait(Cypress.env('waitTime'))
    cy.get(elements.step_22_otr_nationality_l2).should('not.exist')
}
export const uam_step_25 = () => {
    cy.visit('/sponsor-a-child/steps/25').wait(Cypress.env('waitTime'))
    common.uam_step25_header()
    cy.get(elements.summary_text).contains("Who counts as 'living at this address'?").click()
    cy.get(elements.details_text).contains("You must count everyone who will be living at this address").click().wait(Cypress.env('waitTime'))
}
const i_am_not_sure_tname_link = () =>{
    cy.get(elements.summary_text).click().contains("I'm not sure how to enter their name").should('be.visible')
    cy.get(elements.details_text).click().contains('Enter their name as shown on their identity documents.').should('be.visible').wait(Cypress.env('waitTime'))
}
export const uam_step_27 = () => {
    cy.visit('/sponsor-a-child/steps/27').wait(Cypress.env('waitTime'))
    common.uam_step27_header()
    i_am_not_sure_tname_link()
}
export const uam_step_32 = () => {
    cy.visit('/sponsor-a-child/steps/32').wait(Cypress.env('waitTime'))
    common.uam_step32_header()
    i_am_not_sure_tname_link()
}
export const uam_step_35_l1 = () => {
    cy.visit('/sponsor-a-child/steps/35').wait(Cypress.env('waitTime'))
    common.uam_step35_header()
    cy.xpath(elements.spon_consent_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link3).should('exist')
    cy.get(elements.page_heading_cont).contains('Form').should('be.visible')
    cy.go('back')
}
export const uam_step_35_l2 = () => {
    cy.visit('/sponsor-a-child/steps/35').wait(Cypress.env('waitTime'))
    common.uam_step35_header()
    cy.xpath(elements.step35_pcf_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link2).should('exist')
    cy.get(elements.page_heading_cont).contains('Guidance').should('be.visible')
    cy.go('back')
}
export const uam_step_36_l1 = () => {
    cy.visit('/sponsor-a-child/steps/36').wait(Cypress.env('waitTime'))
    common.uam_step36_header()
    cy.get(elements.summary_text).contains('I need help').click().wait(Cypress.env('waitTime'))
    cy.get(elements.details_text).contains('You can only upload these file types: pdf, jpeg, png.').should('be.visible').wait(Cypress.env('waitTime'))
}
export const uam_step_36_l2 = () => {
    cy.visit('/sponsor-a-child/steps/36').wait(Cypress.env('waitTime'))
    common.uam_step36_header()
    cy.get(elements.summary_text).contains('I need help').click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.step36_gui_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link9).should('exist')
    cy.go('back')
}
export const uam_step_37_l1 = () => {
    cy.visit('/sponsor-a-child/steps/37').wait(Cypress.env('waitTime'))
    common.uam_step37_header()
    cy.get(elements.summary_text).contains('I need help').click().wait(Cypress.env('waitTime'))
    cy.get(elements.details_text).contains('You can only upload these file types: pdf, jpeg, png.').should('be.visible')
}
export const uam_step_37_l2 = () => {
    cy.visit('/sponsor-a-child/steps/37').wait(Cypress.env('waitTime'))
    common.uam_step37_header()
    cy.get(elements.summary_text).contains('I need help').click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.step36_gui_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link9).should('exist')
    cy.go('back')
}
export const uam_step_38 = () => {
    cy.visit('/sponsor-a-child/steps/38')
    common.uam_step38_header()
    cy.get(elements.step38_privacy_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link10).should('exist')
    cy.go('back')
}
export const uam_step_39 = () => {
    cy.visit('/sponsor-a-child/steps/39').wait(Cypress.env('waitTime'))
    common.uam_step39_header()
    cy.xpath(elements.step39_gui_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link1).should('exist')
    cy.go('back')
}
export const uam_step_confirm_l1 = () => {
    cy.visit('/sponsor-a-child/confirm').wait(Cypress.env('waitTime'))
    cy.get(elements.app_complete_title).contains('Application complete').click().wait(Cypress.env('waitTime'))
    cy.xpath(elements.gui_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', link1).should('exist')
    cy.go('back')
}
export const uam_step_confirm_l2 = () => {
    cy.visit('/sponsor-a-child/confirm').wait(Cypress.env('waitTime'))
    cy.xpath(elements.comp_ano_app).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', '/sponsor-a-child').should('exist')
}
export const uam_check_your_answers = () => {
    cy.visit('/sponsor-a-child/check-answers').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Check your answers before sending your application').should('be.visible')
    cy.xpath(elements.fn_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step10_header()
    cy.go('back')
    cy.xpath(elements.email_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step14_header()
    cy.go('back')
    cy.xpath(elements.mob_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step15_header()
    cy.go('back')
    cy.xpath(elements.id_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step16_header()
    cy.go('back')
    cy.xpath(elements.dob_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step18_header()
    cy.go('back')
    cy.xpath(elements.nat_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step19_header()
    cy.go('back')
    cy.xpath(elements.oth_nat_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step20_header()
    cy.go('back')
    cy.xpath(elements.child_live_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step23_header()
    cy.go('back')
    cy.xpath(elements.child_fn_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step32_header()
    cy.go('back')
    cy.xpath(elements.child_email_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step33_header()
    cy.go('back')
    cy.xpath(elements.child_dob_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step34_header()
    cy.go('back')
    cy.xpath(elements.uk_const_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step36_header()
    cy.go('back')
    cy.xpath(elements.ukr_const_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step37_header()
    cy.go('back')
    cy.xpath(elements.const_data_share_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step38_header()
    cy.go('back')
    cy.xpath(elements.commit_cond_cng_link).click().wait(Cypress.env('waitTime'))
    common.uam_step39_header()
    cy.go('back')
}