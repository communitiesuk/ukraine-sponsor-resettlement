const element = require('../../pages/EOI/eoi_error_label')

describe('[Frontend-UI]: EOI ERROR LABEL', function () {
  this.beforeEach(() => {
    cy.newSession()
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))
  })

  it('verify property suitability', function () {
    // Eligibility checks
    element.eoi_eligibility_check_ev_start()
    element.eoi_eligibility_check_ev_property_suitability()
    element.eoi_eligibility_check_ev_things_to_consider()
    element.eoi_eligibility_check_ev_6months()

    // Fill in application details
    element.your_details_page_ev_s1_3()
    element.residential_address_validation_ev_s4()
    element.hosting_details_ev_s5()
    element.offering_property_address_validation_ev_s6()
    element.more_properties_ev_s7_8()
    element.how_soon_ev_s9()
    element.no_of_ppl_ev_s10()
    element.accommodation_details_ev_s11()
    element.no_of_bedrooms_ev_s12()
    element.stepfree_access_details_ev_s13()
    element.pets_details_ev_s14()
    element.take_part_in_research_ev_s15()
    element.consent_ev_s16()

    // Submit application
    element.check_your_answers()
  })
})