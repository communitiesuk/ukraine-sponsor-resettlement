const element = require('../../pages/UAM/uam_childs_accomm')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM CHILDS ACCOMMODATION', function () {
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
  context('[Child’s Accommodation] Childs Address Validation Errors', function () {
    it('all fields [empty]', function () {
      element.childs_accommodation_step_23_v1()
    })
    it('one field empty [AL1: empty, TC: valid, PC: valid]', function () {
      element.childs_accommodation_step_23_v2()
    })
    it('one field empty [AL1: valid, TC: empty, PC: valid]', function () {
      element.childs_accommodation_step_23_v3()
    })
    it('one field empty [AL1: valid, TC: valid, PC: empty]', function () {
      element.childs_accommodation_step_23_v4()
    })
    it('two fields empty [AL1: valid, TC: empty, PC: empty]', function () {
      element.childs_accommodation_step_23_v5()
    })
    it('two fields empty [AL1: empty, TC: valid, PC: empty]', function () {
      element.childs_accommodation_step_23_v6()
    })
    it('two fields empty [AL1: empty, TC: empty, PC: valid]', function () {
      element.childs_accommodation_step_23_v7()
    })
    it('one field valid [AL1: valid, TC: invalid, PC: invalid]', function () {
      element.childs_accommodation_step_23_v8()
    })
    it('one field valid [AL1: invalid, TC: valid, PC: invalid]', function () {
      element.childs_accommodation_step_23_v9()
    })
    it('one field valid [AL1: invalid, TC: invalid, PC: valid]', function () {
      element.childs_accommodation_step_23_v10()
    })
    it('two fields valid [AL1: valid, TC: valid, PC: invalid]', function () {
      element.childs_accommodation_step_23_v11()
    })
    it('two fields valid [AL1: invalid, TC: valid, PC: valid]', function () {
      element.childs_accommodation_step_23_v12()
    })
    it('two fields valid [AL1: valid, TC: invalid, PC: valid]', function () {
      element.childs_accommodation_step_23_v13()
    })
    it('all fields [valid]', function () {
      element.childs_accommodation_step_23_v14()
    })
  })
  context('[Child’s Accommodation] Sponsor Address Validation Errors', function () {
    it('all fields [empty]', function () {
      element.childs_accommodation_step_26_v1()
    })
    it('one field empty [AL1: empty, TC: valid, PC: valid]', function () {
      element.childs_accommodation_step_26_v2()
    })
    it('one field empty [AL1: valid, TC: empty, PC: valid]', function () {
      element.childs_accommodation_step_26_v3()
    })
    it('one field empty [AL1: valid, TC: valid, PC: empty]', function () {
      element.childs_accommodation_step_26_v4()
    })
    it('two fields empty [AL1: valid, TC: empty, PC: empty]', function () {
      element.childs_accommodation_step_26_v5()
    })
    it('two fields empty [AL1: empty, TC: valid, PC: empty]', function () {
      element.childs_accommodation_step_26_v6()
    })
    it('two fields empty [AL1: empty, TC: empty, PC: valid]', function () {
      element.childs_accommodation_step_26_v7()
    })
    it('one field valid [AL1: valid, TC: invalid, PC: invalid]', function () {
      element.childs_accommodation_step_26_v8()
    })
    it('one field valid [AL1: invalid, TC: valid, PC: invalid]', function () {
      element.childs_accommodation_step_26_v9()
    })
    it('one field valid [AL1: invalid, TC: invalid, PC: valid]', function () {
      element.childs_accommodation_step_26_v10()
    })
    it('two fields valid [AL1: valid, TC: valid, PC: invalid]', function () {
      element.childs_accommodation_step_26_v11()
    })
    it('two fields valid [AL1: invalid, TC: valid, PC: valid]', function () {
      element.childs_accommodation_step_26_v12()
    })
    it('two fields valid [AL1: valid, TC: invalid, PC: valid]', function () {
      element.childs_accommodation_step_26_v13()
    })
    it('all fields [valid]', function () {
      element.childs_accommodation_step_26_v14()
    })
  })
  context('[Child’s Accommodation] Person Over 16 Who Will Live With The Child Validation Errors', function () {
    it('name: validation errors [GN: empty, FN: empty]', function () {
      element.your_details_name_step_27_v1()
    })
    it('name: validation errors [GN: valid, FN: empty]', function () {
      element.your_details_name_step_27_v2()
    })
    it('name: validation errors [GN: empty, FN: valid]', function () {
      element.your_details_name_step_27_v3()
    })
    it('name: validation errors [GN: invalid, FN: invalid]', function () {
      element.your_details_name_step_27_v4()
    })
    it('name: validation errors [GN: invalid, FN: valid]', function () {
      element.your_details_name_step_27_v5()
    })
    it('name: validation errors [GN: valid, FN: invalid]', function () {
      element.your_details_name_step_27_v6()
    })
    it('name: validation errors [GN: valid, FN: valid]', function () {
      element.your_details_name_step_27_v7()
    })
    })
})


