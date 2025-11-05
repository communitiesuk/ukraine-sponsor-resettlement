const element = require('../../pages/UAM/uam_childs_accomm')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM CHILDS ACCOMMODATION', function () {
  this.beforeEach(() => {
    cy.newSession()
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})

    cy.visit('/sponsor-a-child/start')
    eligibility.uam_eligibility_steps()
  })

  context('[Child’s Accommodation] Childs Address Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/23')
    })

    it('Rejects invalid input', function () {
      element.childs_accommodation_step_23_v1()
      element.childs_accommodation_step_23_v2()
      element.childs_accommodation_step_23_v3()
      element.childs_accommodation_step_23_v4()
      element.childs_accommodation_step_23_v5()
      element.childs_accommodation_step_23_v6()
      element.childs_accommodation_step_23_v7()
      element.childs_accommodation_step_23_v8()
      element.childs_accommodation_step_23_v9()
      element.childs_accommodation_step_23_v10()
      element.childs_accommodation_step_23_v11()
      element.childs_accommodation_step_23_v12()
      element.childs_accommodation_step_23_v13()
    })

    it('Accepts valid input', function () {
      element.childs_accommodation_step_23_v14()
    })
  })

  context('[Child’s Accommodation] Sponsor Address Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/23')
      element.enter_valid_childs_accomodation_address()
      cy.visit('/sponsor-a-child/steps/26')
    })

    it('Rejects invalid input', function () {
      element.childs_accommodation_step_26_v1()
      element.childs_accommodation_step_26_v2()
      element.childs_accommodation_step_26_v3()
      element.childs_accommodation_step_26_v4()
      element.childs_accommodation_step_26_v5()
      element.childs_accommodation_step_26_v6()
      element.childs_accommodation_step_26_v7()
      element.childs_accommodation_step_26_v8()
      element.childs_accommodation_step_26_v9()
      element.childs_accommodation_step_26_v10()
      element.childs_accommodation_step_26_v11()
      element.childs_accommodation_step_26_v12()
      element.childs_accommodation_step_26_v13()
    })

    it('Accepts valid input', function () {
      element.childs_accommodation_step_26_v14()
    })
  })

  context('[Child’s Accommodation] Person Over 16 Who Will Live With The Child Validation Errors', function () {
    this.beforeEach(() => {
      cy.visit('/sponsor-a-child/steps/23')
      element.enter_valid_childs_accomodation_address()
      cy.visit('/sponsor-a-child/steps/27')
    })

    it('Rejects invalid input', function () {
      element.your_details_name_step_27_v1()
      element.your_details_name_step_27_v2()
      element.your_details_name_step_27_v3()
      element.your_details_name_step_27_v4()
      element.your_details_name_step_27_v5()
      element.your_details_name_step_27_v6()
    })

    it('Accepts valid input', () => {
      element.your_details_name_step_27_v7()
    })
  })
})


