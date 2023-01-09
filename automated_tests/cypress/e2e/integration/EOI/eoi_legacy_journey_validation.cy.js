const element = require('../../pages/EOI/legacy_journey_validation')

//Any URL within the individual or organisation routes should redirect the user to "/expression-of-interest/self-assessment/property-suitable" (old routes still existing on the DOM)
describe('[Frontend-UI]: EOI FORM LEGACY JOURNEY VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Individual Journey', function () {
    it('verify individual journey redirects to self assesment /property-suitable page [step 1-3]', function () {
      element.eoi_ind_step_1_3()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 4-6]', function () {
      element.eoi_ind_step_4_6()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 7-8]', function () {
      element.eoi_ind_step_7_8()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 9]', function () {
      element.eoi_ind_step_9()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 10-12]', function () {
      element.eoi_ind_step_10_12()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 13-15]', function () {
      element.eoi_ind_step_13_15()
    })
    it('verify individual journey redirects to self assesment /property-suitable page [step 16-17]', function () {
      element.eoi_ind_step_16_17()
    })
  })
  context('Organisationl Journey', function () {
    it('verify organisation journey redirects to self assesment /property-suitable page [step 1-3]', function () {
      element.eoi_org_step_1_3()
    })
    it('verify organisation journey redirects to self assesment /property-suitable page [step 4-6]', function () {
      element.eoi_org_step_4_6()
    })
    it('verify organisation journey redirects to self assesment /property-suitable page [step 7-9]', function () {
      element.eoi_org_step_7_9()
    })
    it('verify organisation journey redirects to self assesment /property-suitable page [step 10-12]', function () {
      element.eoi_org_step_10_12()
    })
    it('verify organisation journey redirects to self assesment /property-suitable page [step 13-15]', function () {
      element.eoi_org_step_13_15()
    })
    it('verify organisation journey redirects to self assesment /property-suitable page [step 16-17]', function () {
      element.eoi_org_step_16_17()
    }) 
  })
  context('Additional Information', function () {
    it('verify additional-info journey redirects to self assesment /property-suitable page [step 1-3]', function () {
      element.eoi_ad_info_step_1_3()
    })
    it('verify additional-info journey redirects to self assesment /property-suitable page [step 4-6]', function () {
      element.eoi_ad_info_step_4_6()
    })
    it('verify additional-info journey redirects to self assesment /property-suitable page [step 7-9]', function () {
      element.eoi_ad_info_step_7_9()
    })
    it('verify additional-info journey redirects to self assesment /property-suitable page [step 10-12]', function () {
      element.eoi_ad_info_step_10_11()
    })
    it('verify additional-info journey redirects to self assesment /property-suitable page [step 13-15]', function () {
      element.eoi_ad_info_check_ans()
    })
   
  })
})






