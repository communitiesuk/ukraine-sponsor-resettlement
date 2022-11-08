require('cypress-xpath');
const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/bodytext_error.json')
import { faker } from '@faker-js/faker';
const randomBuildingNo = faker.address.buildingNumber()
const randomStreetadd = faker.address.streetAddress()
const randomCityName = faker.address.cityName()

export const residential_address_nv = () => {
    cy.visit('https://ukraine:r3fug3@ukraine-sponsor-resettlement-staging.london.cloudapps.digital/expression-of-interest/steps/4')
    cy.get(elements.coockies_accept).click().wait(1000)
    cy.get(elements.hide_coockie_msg).click().wait(1000)
    cy.get(elements.page_heading).contains('Enter your full residential address').should('be.visible')
    cy.get(elements.addressl1_textbox).clear()
    cy.get(elements.addressl2_textbox).clear()
    cy.get(elements.townorcity_textbox).clear()
    cy.get(elements.postcode_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')
}

export const residential_address_sc = () => {
    cy.get(elements.addressl1_error_textbox).clear().type('A')
    cy.get(elements.townorcity_error_textbox).clear().type('B')
    cy.get(elements.postcode_error_textbox).clear().type('C')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')
}

export const residential_address_tc = () => {
    cy.get(elements.addressl1_error_textbox).clear().type('@1')
    cy.get(elements.townorcity_error_textbox).clear().type('2*')
    cy.get(elements.postcode_error_textbox).clear().type('3^')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')
}

export const residential_address_v1 = () => {
    //ONLY ADDl1 VALID
    cy.get(elements.addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.townorcity_error_textbox).clear()
    cy.get(elements.postcode_error_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).should('not.exist')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //ONLY CITY VALID
    cy.get(elements.addressl1_textbox).clear()
    cy.get(elements.townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.postcode_error_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).should('not.exist')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //ONLY POST-CODE VALID
    cy.get(elements.addressl1_error_textbox).clear()
    cy.get(elements.townorcity_textbox).clear()
    cy.get(elements.postcode_error_textbox).clear().type('NW10 3WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).should('not.exist')
}

export const residential_address_v2 = () => {
    //POST-CODE INVALID, ADDL1 & CITY VALID
    cy.get(elements.addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.postcode_textbox).clear().type("NW10")
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).should('not.exist')
    cy.get(elements.townorcity_error).should('not.exist')
    cy.get(elements.postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //CITY INVALID, ADDL1 & POST-CODE VALID 
    cy.get(elements.addressl1_textbox).clear().type(randomBuildingNo)
    cy.get(elements.townorcity_textbox).clear().type('$$')
    cy.get(elements.postcode_error_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).should('not.exist')
    cy.get(elements.townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.postcode_error).should('not.exist')

    //ADDL1 INVALID, CITY & POST-CODE VALID
    cy.get(elements.addressl1_textbox).clear().type('!!')
    cy.get(elements.townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.postcode_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.townorcity_error).should('not.exist')
    cy.get(elements.postcode_error).should('not.exist')
}

export const residential_address_av = () => {
    //ALL VALID
    cy.get(elements.addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.addressl2_textbox).clear().type(randomStreetadd)
    cy.get(elements.townorcity_textbox).clear().type(randomCityName)
    cy.get(elements.postcode_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.addressl1_error).should('not.exist')
    cy.get(elements.townorcity_error).should('not.exist')
    cy.get(elements.postcode_error).should('not.exist')
    cy.get(elements.difaddress_heading).contains('Is the property you’re offering at a different address to your home?').should('be.visible').wait(500)
}

export const offering_property_address_nv = () => {
    cy.visit('https://ukraine:r3fug3@ukraine-sponsor-resettlement-staging.london.cloudapps.digital/expression-of-interest/steps/6')
    cy.get(elements.page_heading).contains("Enter the address of the property you're offering").should('be.visible')
    cy.get(elements.offering_addressl1_textbox).clear()
    cy.get(elements.offering_addressl2_textbox).clear()
    cy.get(elements.offering_townorcity_textbox).clear()
    cy.get(elements.offering_postcode_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible').wait(500)
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')
}

export const offering_property_address_sc = () => {
    cy.get(elements.offering_addressl1_error_textbox).clear().type('A')
    cy.get(elements.offering_townorcity_error_textbox).clear().type('B')
    cy.get(elements.offering_postcode_error_textbox).clear().type("C")
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')
}
export const offering_property_address_tc = () => {
    cy.get(elements.offering_addressl1_error_textbox).clear().type('@!')
    cy.get(elements.offering_townorcity_error_textbox).clear().type('*£')
    cy.get(elements.offering_postcode_error_textbox).clear().type("12")
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')
}
export const offering_property_address_v1 = () => {
    //ONLY ADDL1 VALID
    cy.get(elements.offering_addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.offering_townorcity_error_textbox).clear()
    cy.get(elements.offering_postcode_error_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).should('not.exist')
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //ONLY CITY VALID
    cy.get(elements.offering_addressl1_textbox).clear()
    cy.get(elements.offering_townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.offering_postcode_error_textbox).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.offering_townorcity_error).should('not.exist')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //ONLY POST-CODE VALID
    cy.get(elements.offering_addressl1_error_textbox).clear()
    cy.get(elements.offering_townorcity_textbox).clear()
    cy.get(elements.offering_postcode_error_textbox).clear().type('NW10 3WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).should('not.exist')
}

export const offering_property_address_v2 = () => {
    //POSTCODE INVALID, ADDL1 & CITY VALID
    cy.get(elements.offering_addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.offering_townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.offering_postcode_textbox).clear().type('NW10')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).should('not.exist')
    cy.get(elements.offering_townorcity_error).should('not.exist')
    cy.get(elements.offering_postcode_error).contains(error.postcode_err_msg).should('be.visible')

    //CITY INVALID, ADDL1 & POST-CODE VALID 
    cy.get(elements.offering_addressl1_textbox).clear().type(randomBuildingNo)
    cy.get(elements.offering_townorcity_textbox).clear().type('$$')
    cy.get(elements.offering_postcode_error_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).should('not.exist')
    cy.get(elements.offering_townorcity_error).contains(error.townorcity_err_msg).should('be.visible')
    cy.get(elements.offering_postcode_error).should('not.exist')

    //ADDL1 INVALID, CITY & POST-CODE VALID
    cy.get(elements.offering_addressl1_textbox).clear().type('!!')
    cy.get(elements.offering_townorcity_error_textbox).clear().type(randomCityName)
    cy.get(elements.offering_postcode_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).contains(error.addl1_err_msg).should('be.visible')
    cy.get(elements.offering_townorcity_error).should('not.exist')
    cy.get(elements.offering_postcode_error).should('not.exist')
}
export const offering_property_address_av = () => {
    //ALL VALID
    cy.get(elements.offering_addressl1_error_textbox).clear().type(randomBuildingNo)
    cy.get(elements.offering_addressl2_textbox).clear().type(randomStreetadd)
    cy.get(elements.offering_townorcity_textbox).clear().type(randomCityName)
    cy.get(elements.offering_postcode_textbox).clear().type('KE15 0WE')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.offering_addressl1_error).should('not.exist')
    cy.get(elements.offering_townorcity_error).should('not.exist')
    cy.get(elements.offering_postcode_error).should('not.exist')
    cy.get(elements.page_heading).contains('Are you offering any more properties?').should('be.visible').wait(500)
}