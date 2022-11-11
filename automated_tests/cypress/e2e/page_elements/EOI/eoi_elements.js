var page_elements = {
    //main
    coockies_accept: "a[value='accept']",
    hide_coockie_msg: ".govuk-button[rel='nofollow']",
    main_heading: '.gem-c-title__text.govuk-heading-l',
    page_heading: '.govuk-heading-l',
    start_button: "a[role='button']",
    yes_radiobtn: "input[value='yes']",
    sa_continue_button: "#selfAssessmentContinueButton",
    error_validation_radio_label: ".govuk-error-message",
    continue_button: "button[type='submit']",
    error_summery_title: "#error-summary-title",
    hinttext:".govuk-hint",
    error_sbox_sel_option_msg:"//a[normalize-space()='You must select an option to continue']",
    //step1-3 
    fullname_label: "label[for='expression-of-interest-fullname-field']",
    fullname_textbox: "#expression-of-interest-fullname-field",
    fullname_error_label: "#expression-of-interest-fullname-error",
    fullname_error_sbox_msg: "//a[normalize-space()='You must enter your full name']",
    fullname_error_textbox: "#expression-of-interest-fullname-field-error",
    email_label:"label[for='expression-of-interest-email-field']",
    email_textbox: "#expression-of-interest-email-field",
    email_error_label: "#expression-of-interest-email-error",
    email_error_textbox: "#expression-of-interest-email-field-error",
    email_error_sbox_msg: "a[data-turbo='false']",
    phonenumber_label:"label[for='expression-of-interest-phone-number-field']",
    phonenumber_textbox:'#expression-of-interest-phone-number-field',
    phonenumber_error_label: "#expression-of-interest-phone-number-error",
    phonenumber_error_textbox: "#expression-of-interest-phone-number-field-error",
    pnonenumber_error_sbox_msg: "//a[normalize-space()='You must enter a valid phone number']",
    //step4   
    addressl1_textbox: "#expression-of-interest-residential-line-1-field",
    addressl2_textbox: "#expression-of-interest-residential-line-2-field",
    townorcity_textbox: "#expression-of-interest-residential-town-field",
    postcode_textbox: "#expression-of-interest-residential-postcode-field",
    addressl1_error_label: "#expression-of-interest-residential-line-1-error",
    townorcity_error_label: "#expression-of-interest-residential-town-error",
    postcode_error_label: "#expression-of-interest-residential-postcode-error",
    addressl1_error_textbox: "#expression-of-interest-residential-line-1-field-error",
    townorcity_error_textbox: "#expression-of-interest-residential-town-field-error",
    postcode_error_textbox: "#expression-of-interest-residential-postcode-field-error",
    addressl1_error_sbox_msg: "//a[normalize-space()='You must enter an address']",
    townorcity_error_sbox_msg: "//a[normalize-space()='You must enter a town or city']",
    postcode_error_sbox_msg: "//a[normalize-space()='You must enter a valid UK postcode']",
    //step5
    difaddress_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    difadd_yes_radiobtn: "#expression-of-interest-different-address-yes-field",
    difadd_yes_error_radiobtn: "#expression-of-interest-different-address-field-error",
    difaddress_error_label: "#expression-of-interest-different-address-error",
    //step6-8
    offeringadd_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    offering_addressl1_textbox: "#expression-of-interest-property-one-line-1-field",
    offering_addressl2_textbox: "#expression-of-interest-property-one-line-2-field",
    offering_townorcity_textbox: "#expression-of-interest-property-one-town-field",
    offering_postcode_textbox: "#expression-of-interest-property-one-postcode-field",
    offering_addressl1_error_label: "#expression-of-interest-property-one-line-1-error",
    offering_townorcity_error_label: "#expression-of-interest-property-one-town-error",
    offering_postcode_error_label: "#expression-of-interest-property-one-postcode-error",
    offering_addressl1_error_textbox: "#expression-of-interest-property-one-line-1-field-error",
    offering_townorcity_error_textbox: "#expression-of-interest-property-one-town-field-error",
    offering_postcode_error_textbox: "#expression-of-interest-property-one-postcode-field-error",
    offering_addressl1_error_sbox_msg: "//a[normalize-space()='You must enter an address']",
    offering_townorcity_error_sbox_msg: "//a[normalize-space()='You must enter a town or city']",
    offering_postcode_error_sbox_msg: "//a[normalize-space()='You must enter a valid UK postcode']",
    more_properties_yes_radiobtn: "#expression-of-interest-more-properties-yes-field",
    more_properties_error_label: "#expression-of-interest-more-properties-error",
    more_properties_yes_error_radiobtn: "#expression-of-interest-more-properties-field-error",
    anymore_properties_label: "label[for='expression-of-interest-more-properties-statement-field']",
    //step9
    start_hosting_heading: '.govuk-fieldset__legend.govuk-fieldset__legend--m',
    asap_radiobtn: '#expression-of-interest-host-as-soon-as-possible-true-field',
    sdate_radiobtn: "#expression-of-interest-host-as-soon-as-possible-false-field",
    sdate_radiobtn_error_label: "#expression-of-interest-host-as-soon-as-possible-error",
    specific_date_radiobtn_error: "#expression-of-interest-host-as-soon-as-possible-false-field",
    sdate_error_label: "#expression-of-interest-hosting-start-date-error",
    sdate_error_sbox_msg: "//a[normalize-space()='Enter a valid start date']",


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

    //step11
    morethanone_radiobtn: "#expression-of-interest-family-type-more-than-one-adult-field",
    nopref_radiobtn: "#expression-of-interest-family-type-no-preference-field",
    accommodation_error_label: "#expression-of-interest-family-type-error",

    sbedroom_textbox: "#expression-of-interest-single-room-count-field",
    sbedroom_error: "#expression-of-interest-single-room-count-error",
    sbedroom_textbox_error: "#expression-of-interest-single-room-count-field-error",

    dbbedroom_textbox: "#expression-of-interest-double-room-count-field", 
    dbbedroom_error: "#expression-of-interest-double-room-count-error", 
    dbbedroom_textbox_error: "#expression-of-interest-double-room-count-field-error", 
    //step13
    stepfree_yta_radiobtn: "#expression-of-interest-step-free-all-field",
    stepfree_error_label: "#expression-of-interest-step-free-error",
    stepfree_idk_radiobtn_error: "#expression-of-interest-step-free-unknown-field",
    //step14
    pets_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    pets_error_label: "#expression-of-interest-allow-pet-error",
    pets_yes_radiobtn: "#expression-of-interest-allow-pet-yes-field",
    pets_no_radiobtn_error: "#expression-of-interest-allow-pet-no-field",
    pets_error_sbox_msg:"a[data-turbo='false']",
    //step15
    research_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    research_yes_radiobtn: "#expression-of-interest-user-research-yes-field",
    research_error_label: "#expression-of-interest-user-research-error",
    research_no_radiobtn_error: "#expression-of-interest-user-research-no-field",
    research_error_sbox_msg:"a[data-turbo='false']",
    //step16
    consent_heading: ".govuk-fieldset__legend.govuk-fieldset__legend--m",
    consent_checkbox: "#expression-of-interest-agree-privacy-statement-true-field",
    consent_checkbox_error: "#expression-of-interest-agree-privacy-statement-field-error",
    consent_error_label: "#expression-of-interest-agree-privacy-statement-error",
    consent_error_sbox_msg:"a[data-turbo='false']",
    //check your answers
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





