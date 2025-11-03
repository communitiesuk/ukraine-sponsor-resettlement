const element = require('../../pages/EOI/eoi_e2e_hp')

describe('[Frontend-UI]: EOI HAPPY PATH', function () {
  it('Submits a complete application with valid data', function () {
    cy.newSession()
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))

    element.eoi_eligibility_check()
    element.your_details_page()
    element.your_property_address()
    element.more_properties()
    element.hosting_details()
    element.accommodation_details()
    element.stepfree_access_details()
    element.pets_details()
    element.take_part_in_research()
    element.consent()
    element.check_your_answers()
    element.accept_send()
  })
})