const element = require('../../pages/EOI/eoi_e2e_hp')

describe('[Frontend-UI]: EOI HAPPY PATH', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })
  
  context('Self Assessment', function () {
    it('verify property suitability', function () {
      element.eoi_eligibility_check()
    })
  })
  context('Registration', function () {
    it('verify details[step 1-3]', function () {
      element.your_details_page()
    })
    it('verify addresses[step 4-6]', function () {
      element.your_property_address()
    })
    it('verify more properties[step 7-8]', function () {
      element.more_properties()
    })
    it('verify hosting details[step 9-10]', function () {
      element.hosting_details()
    })
    it('verify accommodation details[step 11-12]', function () {
      element.accommodation_details()
    })
    it('verify stepfree access [step 13]', function () {
      element.stepfree_access_details()
    })
    it('verify guests to bring their pets [step 14]', function () {
      element.pets_details()
    })
    it('verify take part in research [step 15]', function () {
      element.take_part_in_research()
    })
    it('verify consent page [step 16]', function () {
      element.consent()
    })
  })
  context('Check Answers and Send', function () {
    it('verify answers', function () {
      element.check_your_answers()
    })
    it('verify accept and send', function () {
      element.accept_send()
    })
    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  })
})