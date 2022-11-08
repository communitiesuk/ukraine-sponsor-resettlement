var page_elements = {
    coockies_accept: "a[value='accept']",
    hide_coockie_msg: ".govuk-button[rel='nofollow']",
    main_heading: '.gem-c-title__text.govuk-heading-l',
    page_heading: '.govuk-heading-l',
    start_button: "a[role='button']",
    yes_radiobtn: "input[value='yes']",
    sa_continue_button: "#selfAssessmentContinueButton",
    error_validation: ".govuk-error-message",
    continue_button: "button[type='submit']",

    fullname_label: "label[for='expression-of-interest-fullname-field']",
    fullname_textbox: "#expression-of-interest-fullname-field",
    fullname_error: "#expression-of-interest-fullname-error",
    fullname_error_textbox: "#expression-of-interest-fullname-field-error",
    email_label:"label[for='expression-of-interest-email-field']",
    email_textbox: "#expression-of-interest-email-field",
    email_error: "#expression-of-interest-email-error",
    email_error_textbox: "#expression-of-interest-email-field-error",
    phonenumber_label:"label[for='expression-of-interest-phone-number-field']",
    phonenumber_textbox:'#expression-of-interest-phone-number-field',
    phonenumber_error: "#expression-of-interest-phone-number-error",
    phonenumber_error_textbox: "#expression-of-interest-phone-number-field-error",

    addressl1_textbox: "#expression-of-interest-residential-line-1-field",
    addressl2_textbox: "#expression-of-interest-residential-line-2-field",
    townorcity_textbox: "#expression-of-interest-residential-town-field",
    postcode_textbox: "#expression-of-interest-residential-postcode-field",
    addressl1_error: "#expression-of-interest-residential-line-1-error",
    townorcity_error: "#expression-of-interest-residential-town-error",
    postcode_error: "#expression-of-interest-residential-postcode-error",
    addressl1_error_textbox: "#expression-of-interest-residential-line-1-field-error",
    townorcity_error_textbox: "#expression-of-interest-residential-town-field-error",
    postcode_error_textbox: "#expression-of-interest-residential-postcode-field-error",

    difaddress_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    difadd_yes_radiobtn: "#expression-of-interest-different-address-yes-field",
    difadd_yes_error_radiobtn: "#expression-of-interest-different-address-field-error",

    offeringadd_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    offering_addressl1_textbox: "#expression-of-interest-property-one-line-1-field",
    offering_addressl2_textbox: "#expression-of-interest-property-one-line-2-field",
    offering_townorcity_textbox: "#expression-of-interest-property-one-town-field",
    offering_postcode_textbox: "#expression-of-interest-property-one-postcode-field",
    offering_addressl1_error: "#expression-of-interest-property-one-line-1-error",
    offering_townorcity_error: "#expression-of-interest-property-one-town-error",
    offering_postcode_error: "#expression-of-interest-property-one-postcode-error",
    offering_addressl1_error_textbox: "#expression-of-interest-property-one-line-1-field-error",
    offering_townorcity_error_textbox: "#expression-of-interest-property-one-town-field-error",
    offering_postcode_error_textbox: "#expression-of-interest-property-one-postcode-field-error",

    more_properties_yes_radiobtn: "#expression-of-interest-more-properties-yes-field",
    more_properties_error: "#expression-of-interest-more-properties-error",
    more_properties_yes_error_radiobtn: "#expression-of-interest-more-properties-field-error",
    anymore_properties_label: "label[for='expression-of-interest-more-properties-statement-field']",

    start_hosting_heading: '.govuk-fieldset__legend.govuk-fieldset__legend--m',
    asap_radiobtn: '#expression-of-interest-host-as-soon-as-possible-true-field',
    sdate_radiobtn: "#expression-of-interest-host-as-soon-as-possible-false-field",
    sdate_radiobtn_error: "#expression-of-interest-host-as-soon-as-possible-error",
    sdate_radiobtn_error_select: "#expression-of-interest-host-as-soon-as-possible-false-field",
    sdate_error_heading: "#expression-of-interest-hosting-start-date-error",

    day_textbox:"#expression_of_interest_hosting_start_date_3i",
    day_textbox_error:"#expression-of-interest-hosting-start-date-field-error",
    month_textbox:"#expression_of_interest_hosting_start_date_2i",
    year_textbox:"#expression_of_interest_hosting_start_date_1i",

    adults_textbox: "#expression-of-interest-number-adults-field",
    adults_textbox_error: "#expression-of-interest-number-adults-field-error",
    adults_error: "#expression-of-interest-number-adults-error",
    children_textbox: "#expression-of-interest-number-children-field",
    children_error: "#expression-of-interest-number-children-error",
    children_textbox_error: "#expression-of-interest-number-children-field-error",
    one_adult_living_w_children_error: "#expression-of-interest-number-adults-error",

    morethanone_radiobtn: "#expression-of-interest-family-type-more-than-one-adult-field",
    nopref_radiobtn: "#expression-of-interest-family-type-no-preference-field",
    accommodation_error: "#expression-of-interest-family-type-error",

    sbedroom_textbox: "#expression-of-interest-single-room-count-field",
    sbedroom_error: "#expression-of-interest-single-room-count-error",
    sbedroom_textbox_error: "#expression-of-interest-single-room-count-field-error",

    dbbedroom_textbox: "#expression-of-interest-double-room-count-field", 
    dbbedroom_error: "#expression-of-interest-double-room-count-error", 
    dbbedroom_textbox_error: "#expression-of-interest-double-room-count-field-error", 
    
    stepfacc_yta_radiobtn: "#expression-of-interest-step-free-all-field",
    stepfacc_error: "#expression-of-interest-step-free-error",
    stepfacc_idk_radiobtn_error: "#expression-of-interest-step-free-unknown-field",

    pets_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    pets_error: "#expression-of-interest-allow-pet-error",
    pets_yes_radiobtn: "#expression-of-interest-allow-pet-yes-field",
    pets_no_radiobtn_error: "#expression-of-interest-allow-pet-no-field",

    research_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    research_yes_radiobtn: "#expression-of-interest-user-research-yes-field",
    research_error: "#expression-of-interest-user-research-error",
    research_no_radiobtn_error: "#expression-of-interest-user-research-no-field",

    consent_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    consent_checkbox: "#expression-of-interest-agree-privacy-statement-true-field",
    consent_checkbox_error: "#expression-of-interest-agree-privacy-statement-field-error",
    consent_error: "#expression-of-interest-agree-privacy-statement-error",

    cya_name: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(3) > div:nth-child(1) > dd:nth-child(2)",
    cya_email:"body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(3) > div:nth-child(2) > dd:nth-child(2)",
    cya_phone:"body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(3) > div:nth-child(3) > dd:nth-child(2)",
    registration_complete_heading: ".govuk-panel__title",
    ref_number: "div[class='govuk-panel__body'] strong",
    cya_res_address: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(3) > div:nth-child(4) > dd:nth-child(2)",
    cya_dif_address: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(3) > div:nth-child(5) > dd:nth-child(2)",
    cya_p1_address: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(5) > div:nth-child(1) > dd:nth-child(2)",
    cya_more_properties: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(5) > div:nth-child(2) > dd:nth-child(2)",
    cya_adults: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(7) > div:nth-child(1) > dd:nth-child(2)",
    cya_children: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(7) > div:nth-child(2) > dd:nth-child(2)",

    cya_start_date: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(1) > dd:nth-child(2)",
    cya_accommodate: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(2) > dd:nth-child(2)",
    cya_sbedrooms: "span[title='translation missing: en.4']",
    cya_dbedrooms: "span[title='translation missing: en.2']",
    cya_sf_access: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(5) > dd:nth-child(2)",
    cya_pets: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(6) > dd:nth-child(2)",
    cya_research: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(6) > dd:nth-child(2)",
    cya_pstatement: "body > div:nth-child(5) > main:nth-child(4) > div:nth-child(1) > div:nth-child(1) > dl:nth-child(9) > div:nth-child(8) > dd:nth-child(2)",


    

    
};
module.exports = page_elements;





