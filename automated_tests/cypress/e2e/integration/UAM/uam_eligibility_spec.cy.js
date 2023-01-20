const element = require('../../pages/UAM/uam_eligibility')

describe('[Frontend-UI]: UAM ELIGIBILITY CHECK', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Elegibility Check', function () {
    it('verify eligibility of the sponsor', function () {
      element.uam_eligibility_start()
      element.uam_eligibility_check()
      element.uam_eligibility_step_1()
      element.uam_eligibility_step_2()
      element.uam_eligibility_step_3()
      element.uam_eligibility_step_4()
      element.uam_eligibility_step_5()
      element.uam_eligibility_step_6()
      element.uam_eligibility_step_7()
      element.uam_eligibility_step_9()
      element.uam_eligibility_tasklist()
    })
  })

    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  })






