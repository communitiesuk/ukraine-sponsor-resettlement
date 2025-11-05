const element = require('../../pages/UAM/uam_childs_details')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM CHILDS DETAILS', function () {
  this.beforeEach(() => {
    cy.newSession()
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})

    cy.visit('/sponsor-a-child/start')
    eligibility.uam_eligibility_steps()
  })

  context('[Child’s Details] Childs Name Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/32')
    })

    it('Rejects invalid input', function () {
      element.childs_details_step_32_v1()
      element.childs_details_step_32_v2()
      element.childs_details_step_32_v3()
      element.childs_details_step_32_v4()
      element.childs_details_step_32_v5()
      element.childs_details_step_32_v6()
    })

    it('Accepts valid input', function () {
      element.childs_details_step_32_v7()
    })
  })

  context('[Child’s Details] Childs Email Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/33')
    })

    it('Rejects invalid input', function () {
      element.childs_details_step_33_v1()
      element.childs_details_step_33_v2()
      element.childs_details_step_33_v3()
      element.childs_details_step_33_v4()
      element.childs_details_step_33_v5()
      element.childs_details_step_33_v6()
    })

    it('Accepts valid input', function () {
      element.childs_details_step_33_v7()
    })
  })

  context('[Child’s Details] Childs Phone Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/33')
    })

    it('Rejects invalid input', function () {
      element.childs_details_step_33_v8()
      element.childs_details_step_33_v9()
      element.childs_details_step_33_v10()
      element.childs_details_step_33_v11()
      element.childs_details_step_33_v12()
      element.childs_details_step_33_v13()
    })

    it('Accepts a child who cannot be contacted', function () {
      element.childs_details_step_33_v14()
    })
  })

  context('[Child’s Details] Childs DOB Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/34')
    })

    it('Rejects invalid input', function () {
      element.childs_details_step_34_v1()
      element.childs_details_step_34_v2()
      element.childs_details_step_34_v3()
      element.childs_details_step_34_v4()
      element.childs_details_step_34_v5()
    })

    it('Accepts valid input', () => {
      element.childs_details_step_34_v6()
      element.childs_details_step_34_v7()
      element.childs_details_step_34_v8()
      element.childs_details_step_34_v9()
      element.childs_details_step_34_v10()
    })
  })
})  