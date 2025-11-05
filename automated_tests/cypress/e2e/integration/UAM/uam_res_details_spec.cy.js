const element = require('../../pages/UAM/uam_res_details')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM RESIDENTS DETAILS', function () {
  this.beforeEach(() => {
    cy.newSession()
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})
    cy.visit("/sponsor-a-child/start")
    eligibility.uam_eligibility_steps()
  })

  context('[Residents Details] DOB and ID Validation Errors', function () {
    it('Validates DOB and ID details correctly', function () {
      element.residents_details_step_29()
      element.residents_details_step_29_v1()
      element.residents_details_step_29_v2()
      element.residents_details_step_29_v3()
      element.residents_details_step_29_v4()
      element.residents_details_step_29_v5()
      element.residents_details_step_29_v6(2026)
      element.residents_details_step_29_v7()
      element.residents_details_step_29_v8()
      element.residents_details_step_29_v9()

      element.residents_details_step_31_v1()
      element.residents_details_step_31_v2()
      element.residents_details_step_31_v3()
      element.residents_details_step_31_v4()
      element.residents_details_step_31_v5()
      element.residents_details_step_31_v6()
    })
  })
})
