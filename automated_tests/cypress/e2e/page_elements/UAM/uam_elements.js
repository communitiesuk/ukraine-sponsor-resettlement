var page_elements = {
    //main

    show: "button[aria-label='2. Apply for approval from your local council , Show this section'] span[class='govuk-accordion__section-toggle']",
    hide: "button[aria-label='2. Apply for approval from your local council , Hide this section'] span[class='govuk-accordion__section-toggle-text']",
    spchild_link:"body > div:nth-child(6) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > div:nth-child(5) > div:nth-child(3) > div:nth-child(2) > a:nth-child(5)", 

    main_heading: ".gem-c-title__text.govuk-heading-l",
    page_heading: ".govuk-heading-l",
    page_heading_xl: ".gem-c-title__text.govuk-heading-xl",
    startnow_button: 'a[role="button"]',
    page_body: '.govuk-body',
    continue_button_ec: 'a[role="button"]',
    continue_button: 'button[type="submit"]',
    continue_button_other: "a[class='govuk-button']",
    insettext: '.govuk-inset-text',
    summary_text: ".govuk-details__summary-text",
    //step1
    step1_radio_btn_yes: '#unaccompanied-minor-is-under-18-yes-field',
    eligibility_step1_page_error_u18: '#unaccompanied-minor-is-under-18-error',
    eligibility_step1_page_error_box: '#error-summary-title',
    eligibility_step1_page_error_radion_btn_no: '#unaccompanied-minor-is-under-18-no-field',
    ligibility_step1_page_error_radion_btn_yes: '#unaccompanied-minor-is-under-18-field-error',
    //step2
    eligibility_step2_page_error_before_31_december: '#unaccompanied-minor-is-living-december-error',
    eligibility_step2_page_error_box: '#error-summary-title',
    eligibility_step2_page_error_radion_btn_no: '#unaccompanied-minor-is-living-december-no-field',
    eligibility_step2_page_error_radion_btn_yes: '#unaccompanied-minor-is-living-december-field-error',
    eligibility_step2_radio_btn_yes: '#unaccompanied-minor-is-living-december-yes-field',
    step2_radio_btn_no: '#unaccompanied-minor-is-living-december-no-field',
    step2_bodytext: '#unaccompanied-minor-is-living-december-hint',
    //step3
    eligibility_step3_page_error_after_31_december: '#unaccompanied-minor-is-born-after-december-error',
    eligibility_step3_page_error_radion_btn_no: '#unaccompanied-minor-is-born-after-december-no-field',
    step3_radio_btn_yes: '#unaccompanied-minor-is-born-after-december-yes-field',
    //step4
    eligibility_step4_page_error__parent_or_legal_guardian: '#unaccompanied-minor-is-unaccompanied-error',
    eligibility_step4_page_error_radio_btn_yes: '#unaccompanied-minor-is-unaccompanied-field-error',
    step4__parent_guardian_radio_btn_no: '#unaccompanied-minor-is-unaccompanied-no-field',
    eligibility_step4_page_error_radio_btn_no: '#unaccompanied-minor-is-unaccompanied-no-field',
    step4_bodytext: '#unaccompanied-minor-is-unaccompanied-hint',
    //step5
    eligibility_step5_page_error_consent_forms: '#unaccompanied-minor-is-consent-error',
    eligibility_step5_page_error_radio_btn_no: '#unaccompanied-minor-is-consent-no-field',
    step5_consent_radio_btn_yes: '#unaccompanied-minor-is-consent-yes-field',
    eligibility_step5_page_error_radio_btn_yes: '#unaccompanied-minor-is-consent-field-error',
    step5_bodytext: '#unaccompanied-minor-is-consent-hint',
    step5_guidance_link: '//a[contains(text(),"Read guidance about which consent forms are requir")]',
    //step6
    eligibility_step6_page_error_minimum_period: '#unaccompanied-minor-is-committed-error',
    eligibility_step6_page_error_radio_btn_no: '#unaccompanied-minor-is-committed-no-field',
    step6_minimum_period_radio_btn_yes: '#unaccompanied-minor-is-committed-yes-field',
    eligibility_step6_page_error_radio_btn_yes: '#unaccompanied-minor-is-committed-field-error',
    //step7
    eligibility_step7_page_error_minimum_period: '#unaccompanied-minor-is-permitted-error',
    eligibility_step7_page_error_radio_btn_no: '#unaccompanied-minor-is-permitted-no-field',
    step7_minimum_period_radio_btn_yes: '#unaccompanied-minor-is-permitted-yes-field',
    eligibility_step7_page_error_radio_btn_yes: '#unaccompanied-minor-is-permitted-field-error',
    //step9
    step9_body_text: '.govuk-body',
    step9_start_application_btn: 'a[role="button"]',
    //tasklist
    tasklist_page_body: 'div[class="govuk-grid-column-two-thirds"] p strong',
    application_incomplete: 'div[class="govuk-grid-column-two-thirds"] p strong',
    your_details_heading: 'li:nth-child(1) h2:nth-child(1)',
    childs_accormadation_heading: "(//h2[@class='app-task-list__section'])[2]",
    childs_details_heading: "(//h2[@class='app-task-list__section'])[3]",
    send_your_application_heading: "(//h2[@class='app-task-list__section'])[4]",
    //step10
    name: 'a[href="/sponsor-a-child/steps/10"]',
    save_and_return_label: '.govuk-link',
    given_names_label: 'label[for="unaccompanied-minor-given-name-field"]',
    family_name_label: 'label[for="unaccompanied-minor-family-name-field"]',
    given_names_textbox: '#unaccompanied-minor-given-name-field',
    family_name_textbox: '#unaccompanied-minor-family-name-field',
    //step11
    known_by_another_name_hinttext: '#unaccompanied-minor-has-other-names-hint',
    select_no: '#unaccompanied-minor-has-other-names-field',
    select_yes: '#unaccompanied-minor-has-other-names-true-field',
    //step12
    other_given_names_label: "label[for='unaccompanied-minor-other-given-name-field']",
    other_family_name_label: "label[for='unaccompanied-minor-other-family-name-field']",
    other_given_names_textbox: '#unaccompanied-minor-other-given-name-field',
    other_family_name_textbox: '#unaccompanied-minor-other-family-name-field',
    //step13
    other_added_names_label: 'tr>td:nth-child(1)',
    name_completed: '//strong[normalize-space()="Completed"]',
    //step14
    contact_details_link: 'a[href="/sponsor-a-child/steps/14"]',
    email_ad_body: '.govuk-body',
    email_ad_label: 'label[for="unaccompanied-minor-email-field"]',
    confirm_email_ad_label: 'label[for="unaccompanied-minor-email-confirm-field"]',
    email_ad_textbox: '#unaccompanied-minor-email-field',
    confirm_email_ad_textbox: '#unaccompanied-minor-email-confirm-field',
    //step15
    mobile_number_body: '.govuk-body',
    mobile_number_label: 'label[for="unaccompanied-minor-phone-number-field"]',
    confirm_mobile_number_label: 'label[for="unaccompanied-minor-phone-number-confirm-field"]',
    mobile_number_textbox: '#unaccompanied-minor-phone-number-field',
    confirm_mobile_number_textbox: '#unaccompanied-minor-phone-number-confirm-field',
    contact_details_completed: "strong[class='govuk-tag app-task-list__tag ']",
    //step16
    additional_details: 'a[href="/sponsor-a-child/steps/16"]',
    passport_label: 'label[for="unaccompanied-minor-identification-type-passport-field"]',
    ni_label: 'label[for="unaccompanied-minor-identification-type-national-identity-card-field"]',
    refugee_teavel_doc_label: 'label[for="unaccompanied-minor-identification-type-refugee-travel-document-field"]',
    dont_have_any_label: 'label[for="unaccompanied-minor-identification-type-none-field"]',
    //step17
    passport_nm_radio_button: '#unaccompanied-minor-identification-type-passport-field',
    passport_nm_textbox: '#unaccompanied-minor-passport-identification-number-field',
    //step18
    day_textbox: '#unaccompanied_minor_sponsor_date_of_birth_3i',
    month_textbox: '#unaccompanied_minor_sponsor_date_of_birth_2i',
    year_textbox: '#unaccompanied_minor_sponsor_date_of_birth_1i',
    //step19
    nationality_label: "label[for='unaccompanied-minor-nationality-field']",
    nationality_dropdown: '#unaccompanied-minor-nationality-field',
    //step20
    other_nationalities_hint: '#unaccompanied-minor-has-other-nationalities-hint',
    other_nationalities_yes_radio_button: '#unaccompanied-minor-has-other-nationalities-true-field',
    other_nationalities_no_radio_button: '#unaccompanied-minor-has-other-nationalities-field',
    //step21
    other_nationality_hint: "#unaccompanied-minor-other-nationality-hint",
    other_nationality_dropdown: '#unaccompanied-minor-other-nationality-field',
    //step22
    listed_other_nationalities: "td:nth-child(1)",
    //verify task completed
    completed_1_of_4_label: "//p[normalize-space()='You have completed 1 of 4 sections.']",
    completed_name: "//body[1]/div[2]/main[1]/div[1]/div[1]/ol[1]/li[1]/ul[1]/li[2]/strong[1]",
    completed_details: "//body[1]/div[2]/main[1]/div[1]/div[1]/ol[1]/li[1]/ul[1]/li[2]/strong[1]",
    completed_ad_details: "//body[1]/div[2]/main[1]/div[1]/div[1]/ol[1]/li[1]/ul[1]/li[3]/strong[1]",
    //step23    
    address_link: 'a[href="/sponsor-a-child/steps/23"]',
    child_address_line1_label: 'label[for="unaccompanied-minor-residential-line-1-field"]',
    child_address_line2_label: 'label[for="unaccompanied-minor-residential-line-2-field"]',
    child_town_city_label: 'label[for="unaccompanied-minor-residential-town-field"]',
    child_postcode_label: 'label[for="unaccompanied-minor-residential-postcode-field"]',
    child_address_line1_textbox: '#unaccompanied-minor-residential-line-1-field',
    child_address_line2_textbox: '#unaccompanied-minor-residential-line-2-field',
    child_town_city_textbox: '#unaccompanied-minor-residential-town-field',
    child_postcode_textbox: '#unaccompanied-minor-residential-postcode-field',
    //step24
    child_address_validation_text: '.govuk-inset-text',
    sponsor_living_at_the_same_address_hint: '#unaccompanied-minor-different-address-hint',
    sponsor_living_at_the_same_address_no_button: '#unaccompanied-minor-different-address-no-field',
    //step26
    sponsor_address_line1_label: 'label[for="unaccompanied-minor-sponsor-address-line-1-field"]',
    sponsor_address_line2_label: 'label[for="unaccompanied-minor-sponsor-address-line-2-field"]',
    sponsor_town_city_label: 'label[for="unaccompanied-minor-sponsor-address-town-field"]',
    sponsor_postcode_label: 'label[for="unaccompanied-minor-sponsor-address-postcode-field"]',
    sponsor_address_line1_textbox: '#unaccompanied-minor-sponsor-address-line-1-field',
    sponsor_address_line2_textbox: '#unaccompanied-minor-sponsor-address-line-2-field',
    sponsor_town_city_textbox: '#unaccompanied-minor-sponsor-address-town-field',
    sponsor_postcode_textbox: '#unaccompanied-minor-sponsor-address-postcode-field',
    //step27
    over16_person_given_names_label: "label[for='unaccompanied-minor-adult-given-name-field']",
    over16_person_family_name_label: "label[for='unaccompanied-minor-adult-family-name-field']",
    over16_person_given_names_textbox: '#unaccompanied-minor-adult-given-name-field',
    over16_person_family_name_textbox: '#unaccompanied-minor-adult-family-name-field',
    //step28
    residents_header: '.govuk-table__head',
    over16_persons_name: 'td:nth-child(1)',
    add_another_person_button: 'a[role="button"]',
    add_person_continue_button: 'a[class="govuk-button"]',
    //verify completed 2 of 5
    completed_2_of_5_label: ".govuk-grid-column-two-thirds > :nth-child(3)",
    completed_address: "//li[2]//ul[1]//li[1]//strong[1]",
    completed_live_there: ":nth-child(2) > .app-task-list__items > :nth-child(2) > .govuk-tag",
    //step29
    residents_details_link: "//a[normalize-space()='OVER SIXTEEN details']",
    residents_details_inserttext: '.govuk-inset-text',
    residents_details_hinttext: '#unaccompanied-minor-minor-date-of-birth-hint',
    residents_details_day_textbox: '#unaccompanied_minor_adult_date_of_birth_3i',
    residents_details_month_textbox: '#unaccompanied_minor_adult_date_of_birth_2i',
    residents_details_year_textbox: '#unaccompanied_minor_adult_date_of_birth_1i',
    residents_details_continue_button: 'button[type="submit"]',
    residents_nationality_label: "label[for='unaccompanied-minor-adult-nationality-field']",
    residents_nationality_dropdown: '#unaccompanied-minor-adult-nationality-field',
    residents_pp_radio_button: "#unaccompanied-minor-adult-identification-type-passport-field",
    residents_pp_number_label: "label[for='unaccompanied-minor-adult-passport-identification-number-field']",
    residents_pp_number_textbox: '#unaccompanied-minor-adult-passport-identification-number-field',
    residents_rtdn_radio_button: "#unaccompanied-minor-adult-identification-type-refugee-travel-document-field",
    residents_rtdn_number_label: "label[for='unaccompanied-minor-adult-refugee-identification-number-field']",
    residents_rtdn_number_textbox: '#unaccompanied-minor-adult-refugee-identification-number-field',
    residents_ni_radio_button: "#unaccompanied-minor-adult-identification-type-national-identity-card-field",
    residents_ni_number_label: "label[for='unaccompanied-minor-adult-id-identification-number-field']",
    residents_ni_number_textbox: '#unaccompanied-minor-adult-id-identification-number-field',
    //verify completed 3 of 5
    completed_3_of_5_label: ".govuk-grid-column-two-thirds > :nth-child(3)",
    completed_residents_details: "strong[class='govuk-tag app-task-list__tag ']",
    not_started_data: 'body > div:nth-child(6) > main:nth-child(3) > div:nth-child(1) > div:nth-child(1) > ol:nth-child(4) > li:nth-child(4) > ul:nth-child(2) > li:nth-child(1) > strong:nth-child(2)',
    not_started_eligibility: 'body > div:nth-child(6) > main:nth-child(3) > div:nth-child(1) > div:nth-child(1) > ol:nth-child(4) > li:nth-child(4) > ul:nth-child(2) > li:nth-child(2) > strong:nth-child(2)',
    cannot_start_yet: "//strong[normalize-space()='Cannot start yet']",
    //step32
    childs_personal_details_link: "a[href='/sponsor-a-child/steps/32']",
    childs_personal_details_givennames_label: "label[for='unaccompanied-minor-minor-given-name-field']",
    childs_personal_details_familyname_label: "label[for='unaccompanied-minor-minor-family-name-field']",
    childs_personal_details_givennames_textbox: "#unaccompanied-minor-minor-given-name-field",
    childs_personal_details_familyname_textbox: "#unaccompanied-minor-minor-family-name-field",
    //step33
    childs_personal_details_insettext: '.govuk-inset-text',
    cpd_cbcontacted_label: "label[for='unaccompanied-minor-minor-contact-type-none-field']",
    cpd_email_checkbox: '#unaccompanied-minor-minor-contact-type-email-field',
    cpd_phone_checkbox: '#unaccompanied-minor-minor-contact-type-telephone-field',
    cpd_email_textkbox: '#unaccompanied-minor-minor-email-field',
    cpd_cemail_textbox: '#unaccompanied-minor-minor-email-confirm-field',
    cpd_pnumber_textkbox: '#unaccompanied-minor-minor-phone-number-field',
    cpd_cpnumber_textbox: '#unaccompanied-minor-minor-phone-number-confirm-field',
    cpd_day_textbox: '#unaccompanied_minor_minor_date_of_birth_3i',
    cpd_month_textbox: '#unaccompanied_minor_minor_date_of_birth_2i',
    cpd_year_textbox: '#unaccompanied_minor_minor_date_of_birth_1i',
    //step35
    consentform_link: "a[href='/sponsor-a-child/steps/35']",
    consentform_choosefile_button: '#unaccompanied-minor-uk-parental-consent-field',
    consentform_completed_tag: "strong[class='govuk-tag app-task-list__tag ']",
    //step37
    ukrconsentform_link: "a[href='/sponsor-a-child/steps/37']",
    ukrconsentform_choosefile_button: "#unaccompanied-minor-ukraine-parental-consent-field",
    ukrconsentform_completed_tag: "(//strong[contains(@class,'govuk-tag app-task-list__tag')][normalize-space()='Completed'])[2]",
    //verify completed 4 of 5
    completed_4_of_5_label: "div[class='govuk-width-container'] p:nth-child(3)",
    completed_childs_details: ":nth-child(3) > .app-task-list__items > :nth-child(1) > .govuk-tag",
    completed_consent_form: ":nth-child(4) > .app-task-list__items > :nth-child(2) > .govuk-tag",
    completed_ukrconsent_form: ":nth-child(4) > .app-task-list__items > :nth-child(3) > .govuk-tag",
    //step38
    confirm_data_link: "a[href='/sponsor-a-child/steps/38']",
    confirm_data_checkbox: '#unaccompanied-minor-privacy-statement-confirm-true-field',
    confirm_eligibility_link: "a[href='/sponsor-a-child/steps/39']",
    confirm_eligibility_checkbox: '#unaccompanied-minor-sponsor-declaration-true-field',
    //send application
    check_your_answers_link: "a[href='/sponsor-a-child/check-answers']",
    answers_fullname: "//dd[normalize-space()='QA AUTOMATION TEST']",
    answers_othernames :":nth-child(3) > :nth-child(2) > .govuk-summary-list__value",
    answers_email: ":nth-child(3) > :nth-child(3) > .govuk-summary-list__value",
    answers_mobile: ":nth-child(3) > :nth-child(4) > .govuk-summary-list__value",
    answers_id: " :nth-child(3) > :nth-child(5) > .govuk-summary-list__value",
    answers_dob: " :nth-child(3) > :nth-child(6) > .govuk-summary-list__value",
    answers_nationality: " :nth-child(7) > .govuk-summary-list__value",
    answers_other_nationalities: ":nth-child(3) > :nth-child(8)",
    answers_child_address: ":nth-child(5) > :nth-child(1) > .govuk-summary-list__value",
    answers_over16_name: ":nth-child(5) > :nth-child(2) > .govuk-summary-list__value",
    
    answers_child_fullname: ":nth-child(7) > :nth-child(1) > .govuk-summary-list__value",
    answers_child_email: ":nth-child(7) > :nth-child(2) > .govuk-summary-list__value",
    answers_child_phone: ":nth-child(7) > :nth-child(3) > .govuk-summary-list__value",
    answers_child_dob: ":nth-child(7) > :nth-child(4) > .govuk-summary-list__value",

    answers_consent1: ":nth-child(7) > :nth-child(5) > .govuk-summary-list__value",
    answers_consent2: ":nth-child(7) > :nth-child(6) > .govuk-summary-list__value",

    answers_agree1: ":nth-child(9) > :nth-child(1) > .govuk-summary-list__value",
    answers_agree2: ":nth-child(9) > :nth-child(2) > .govuk-summary-list__value",















    
    accept_send: "button[type='submit']",
    app_complete_title: ".govuk-panel__title",
    ref_number: "div[class='govuk-panel__body'] strong"
};
module.exports = page_elements;
