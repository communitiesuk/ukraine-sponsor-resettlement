const element = require('../../pages/EOI/error_label_validation')

describe('[Frontend-UI]: EOI FORM ERROR LABEL VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })
  
  context('Self Assessment', function () {
    it('verify property suitability', function () {
      element.eoi_eligibility_check_ev()
    })
  })

  context('Registration', function () {
    it('verify details [step 1-3]', function () {
      element.your_details_page_ev()
    })

    it('verify residential address [step 4]', function () {
      element.residential_address_validation_ev()
    })

    it('verify offering property address[step 5-6]', function () {
      element.hosting_details_ev()
      element.offering_property_address_validation_ev()
    })

    it('verify more properties to offer [step 7-9]', function () {
      element.more_properties_ev()
      element.how_soon_ev()
    })

    it('verify number of people live in the property[step 10]', function () {
      element.no_of_ppl_ev()
    })

    it('verify accommodation details [step 11-12]', function () {
      element.accommodation_details_ev()
      element.no_of_bedrooms_ev()
    })

    it('verify stepfree access [step 13]', function () {
      element.stepfree_access_details_ev()
    })

    it('verify guests to bring their pets [step 14]', function () {
      element.pets_details_ev()
    })

    it('verify take part in research [step 15]', function () {
      element.take_part_in_research_ev()
    })

    it('verify consent page [step 16]', function () {
      element.consent_ev()
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






