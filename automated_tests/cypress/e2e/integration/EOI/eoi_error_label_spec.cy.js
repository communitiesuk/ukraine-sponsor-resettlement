const element = require('../../pages/EOI/eoi_error_label')

describe('[Frontend-UI]: EOI ERROR LABEL VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Self Assessment', function () {
    it('verify property suitability [start page]', function () {
      element.eoi_eligibility_check_ev_start()
    })
    it('verify property suitability [suitability]', function () {
      element.eoi_eligibility_check_ev_property_suitability()
    })
    it('verify property suitability [things to consider]', function () {
      element.eoi_eligibility_check_ev_things_to_consider()
    })
    it('verify property suitability [hosting for at least 6 months]', function () {
      element.eoi_eligibility_check_ev_6months()
    })
  })
  context('Registration', function () {
    it('verify details [step 1-3]', function () {
      element.your_details_page_ev_s1_3()
    })
    it('verify residential address [step 4]', function () {
      element.residential_address_validation_ev_s4()
    })
    it('verify hosting details[step 5]', function () {
      element.hosting_details_ev_s5()
    })
    it('verify offering property address[step 6]', function () {
      element.offering_property_address_validation_ev_s6()
    })
    it('verify more properties to offer [step 7-9]', function () {
      element.more_properties_ev_s7_8()
      element.how_soon_ev_s9()
    })
    it('verify number of people live in the property[step 10]', function () {
      element.no_of_ppl_ev_s10()
    })
    it('verify accommodation details [step 11]', function () {
      element.accommodation_details_ev_s11()
    })
    it('verify number of rooms [step 12]', function () {
      element.no_of_bedrooms_ev_s12()
    })
    it('verify stepfree access [step 13]', function () {
      element.stepfree_access_details_ev_s13()
    })
    it('verify guests to bring their pets [step 14]', function () {
      element.pets_details_ev_s14()
    })
    it('verify take part in research [step 15]', function () {
      element.take_part_in_research_ev_s15()
    })
    it('verify consent page [step 16]', function () {
      element.consent_ev_s16()
    })
  })
  context('Check Answers and Send', function () {
    it('verify answers', function () {
      element.check_your_answers()
    })
    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  })
})