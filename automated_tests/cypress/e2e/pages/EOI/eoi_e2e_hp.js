const elements = require('../../page_elements/EOI/eoi_elements')
const bodytext = require('../../../fixtures/eoi_bodytext.json')
const secrets = require('../../../fixtures/eoi_bodytext_secrets.json')
const alfa = require('../../pages/EOI/eoi_links')

export const eoi_eligibility_check = () => {
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible')
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Important things to consider').should('be.visible')
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Can you commit to hosting for at least 6 months?').should('be.visible')
    cy.get(elements.yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Now we need your information').should('be.visible')
    cy.get(elements.sa_continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_details_page = () => {
    cy.get(elements.fullname_label).contains('Enter your full name').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.fullname_textbox).clear().type(secrets.user_name).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.email_label).contains('Enter your email address').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.email_textbox).clear().type(secrets.email).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.phonenumber_label).contains('Enter a telephone number, like 01632 960 001, 07700 900 982 or +44 808 157 0192').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.phonenumber_textbox).clear().type(secrets.phoneno).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const your_property_address = () => {
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.addressl1_textbox).clear().type(secrets.building_no)
    cy.get(elements.addressl2_textbox).clear().type(secrets.street)
    cy.get(elements.townorcity_textbox).clear().type(secrets.city)
    cy.get(elements.postcode_textbox).clear().type(secrets.postcode).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.difadd_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("Enter the address of the property you're offering").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.offering_addressl1_textbox).clear().type('Property One Address').wait(Cypress.env('waitTime'))
    cy.get(elements.offering_addressl2_textbox).clear().type(secrets.street)
    cy.get(elements.offering_townorcity_textbox).clear().type(secrets.city)
    cy.get(elements.offering_postcode_textbox).clear().type(secrets.p1_postcode).wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const more_properties = () => {
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.more_properties_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.anymore_properties_label).contains(bodytext.more_properties_to_offer).should('be.visible')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const hosting_details = () => {
    cy.get(elements.start_hosting_heading).contains('How soon can you start hosting someone?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.asap_radiobtn).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible')
    cy.get(elements.adults_textbox).clear().type('6')
    cy.get(elements.children_textbox).clear().type('4')
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const accommodation_details = () => {
    cy.get(elements.page_heading).contains('Who would you like to offer accommodation to? ').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.morethanone_radiobtn).click()
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('How many bedrooms are available for guests in the property you’re registering now?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.sbedroom_textbox).clear().type('4')
    cy.get(elements.dbbedroom_textbox).clear().type('2').wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const stepfree_access_details = () => {
    cy.get(elements.page_heading).contains('Does the property, or any of the properties, have step-free access?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.stepfree_yta_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const pets_details = () => {
    cy.get(elements.pets_heading).contains('Would you consider allowing guests to bring their pets?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.pets_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const take_part_in_research = () => {
    cy.get(elements.research_heading).contains('Would you like to take part in research to help us improve the Homes for Ukraine service?').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.research_yes_radiobtn).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const consent = () => {
    cy.get(elements.consent_heading).contains('Confirm you have read the privacy statement').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.consent_checkbox).click().wait(Cypress.env('waitTime'))
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
}
export const check_your_answers = () => {
    cy.get(elements.page_heading).contains('Check your answers before sending your registration').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.cya_name).contains(secrets.user_name).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.cya_email).contains(secrets.email).should('be.visible')
    cy.get(elements.cya_phone).contains(secrets.phoneno).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.cya_res_address).should("contain.text", secrets.postcode)
    cy.get(elements.cya_dif_address).should("contain.text", 'Yes')
    cy.get(elements.cya_p1_address).should("contain.text", secrets.p1_postcode)
    cy.get(elements.cya_more_properties).should("contain.text", 'Yes')
    cy.get(elements.cya_adults).should("contain.text", '6')
    cy.get(elements.cya_children).should("contain.text", '4')
    cy.get(elements.cya_start_date).should("contain.text", 'As soon as possible').wait(Cypress.env('waitTime'))
    cy.get(elements.cya_accommodate).should("contain.text", 'More than one adult')
    cy.get(elements.cya_sbedrooms).should("contain.text", '4')
    cy.get(elements.cya_dbedrooms).should("contain.text", '2')
    cy.get(elements.cya_sf_access).should("contain.text", "Yes, all")
    cy.get(elements.cya_pets).should("contain.text", 'Yes')
    cy.get(elements.cya_research).should("contain.text", 'Yes')
    cy.get(elements.cya_pstatement).should("contain.text", 'Agreed').wait(Cypress.env('waitTime'))
}
const send_your_registration_details = () => {
    cy.get(elements.continue_button).click().wait(Cypress.env('waitTime'))
    cy.get(elements.registration_complete_heading).contains('Thank you for registering').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.ref_number).contains('EOI').should('be.visible').wait(Cypress.env('waitTime'))
}
export const accept_send = () => {
    let local = ('http://localhost:8080');
    let staging = ('https://ukraine-sponsor-resettlement-staging.london.cloudapps.digital/')
    let prod = ('https://apply-to-offer-homes-for-ukraine.service.gov.uk/')
    //get the current url and save it in a file
    cy.url().then(envurl => {
        const saveLocation = `cypress/fixtures/envlinks.txt`
        cy.writeFile(saveLocation, { envurl }).wait(Cypress.env('waitTime'))
    })
    //get the url from the saved location and save it as a variable
    cy.readFile(`cypress/fixtures/envlinks.txt`).then((saved_url) => {
        //localhost
        if (saved_url.includes(local)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            send_your_registration_details()
            cy.log("[This is LOCALHOST / REGISTRATION DETAILS SENT]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '')
            return
        }
        //staging
        else if (saved_url.includes(staging)) {
            cy.url().should("have.contain", 'london.cloudapps.digital')
            send_your_registration_details()
            cy.log("[This is STAGING / REGISTRATION DETAILS SENT]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '')
            return
        }
        //prod
        else if (saved_url.includes(prod)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            cy.log('[************* This is PROD / REGISTRATION DETAILS NOT SENT *************]()')
            cy.log('************* **This is PROD / REGISTRATION DETAILS NOT SENT** *************')
            cy.log('[************* This is PROD / REGISTRATION DETAILS NOT SENT *************]()')
            cy.writeFile('cypress/fixtures/envlinks.txt', '')
            return
        }
        else {
            alfa.validation_error()
        }
    })
}
