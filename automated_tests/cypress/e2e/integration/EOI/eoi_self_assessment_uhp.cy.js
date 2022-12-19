const element = require('../../pages/EOI/self_assessment_uhp')

describe('[Frontend-UI]: EOI FORM SELF ASSESSMENT UHP', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Self Assessment', function () {
    it('verify self assessment [Start Page]', function () {
      element.eoi_eligibility_check_start()
    })
    it('verify self assessment [Property suitability page, Answer: No]', function () {
      element.eoi_eligibility_check_property_suitability()
    })
    it('verify self assessment [Important things to consider page, Answer: No]', function () {
      element.eoi_eligibility_check_imp_things()
    })
    it('verify self assessment [Hosting for at least 6 months? page, Answer: No]', function () {
      element.eoi_eligibility_check_hosting_6months()
    })
    it('verify self assessment [Now we need your information page]', function () {
      element.eoi_eligibility_check_need_information()
    })
  })

    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  
})