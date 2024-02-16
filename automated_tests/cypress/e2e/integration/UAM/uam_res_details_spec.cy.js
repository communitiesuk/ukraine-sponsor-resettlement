const element = require('../../pages/UAM/uam_res_details')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM RESIDENTS DETAILS', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Eligibility Check', function () {
    it('verify eligibility', function () {
      eligibility.uam_eligibility_steps()
    })
  })
  context('[Residents Details] DOB Validation Errors', function () {
    it('all fields empty', function () {
      element.residents_details_step_29()
      element.residents_details_step_29_v1()
    })
    it('two fields empty', function () {
      element.residents_details_step_29_v2()
    })
    it('one field empty', function () {
      element.residents_details_step_29_v3()
    })
    it('one field valid', function () {
      element.residents_details_step_29_v4()
    })
    it('two fields valid', function () {
      element.residents_details_step_29_v5()
    })
    it('all valid [future date]', function () {
      element.residents_details_step_29_v6(2026)
    })
    it('all valid [past date (1 year ago)] ', function () {
      element.residents_details_step_29_v7()
    })
    it('all valid [past date (15 years ago)] ', function () {
      element.residents_details_step_29_v8()
    })
    it('all valid: past date [18 years ago] ', function () {
      element.residents_details_step_29_v9()
    })
  })
  context('[Residents Details] ID Validation Errors', function () {
    it('none selected', function () {
      element.residents_details_step_31_v1()
    })
    it('passport [validation errors]', function () {
      element.residents_details_step_31_v2()
    })
    it('national identity card [validation errors]', function () {
      element.residents_details_step_31_v3()
    })
    it('biometric residence [validation errors]', function () {
      element.residents_details_step_31_v4()
    })
    it('photo driving licence [validation errors]', function () {
      element.residents_details_step_31_v5()
    })
    it("I don't have any of these [validation errors]", function () {
      element.residents_details_step_31_v6()
    })
  })
})
