const element = require('../../pages/UAM/uam_val_err_childs_details')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM VALIDATION ERRORS [CHILDS DETAILS]', function () {
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
  context('[Child’s Details] Childs Name Validation Errors', function () {
    it('both feilds empty [GN: empty, FN: empty]', function () {
      element.childs_details_step_32_v1()
    })
    it('one field empty [GN: valid, FN: empty]', function () {
      element.childs_details_step_32_v2()
    })
    it('one field empty [GN: empty, FN: valid]', function () {
      element.childs_details_step_32_v3()
    })
    it('both fields invalid [GN: invalid, FN: invalid]', function () {
      element.childs_details_step_32_v4()
    })
    it('one field valid: [GN: invalid, FN: valid]', function () {
      element.childs_details_step_32_v5()
    })
    it('one field valid: [GN: valid, FN: invalid]', function () {
      element.childs_details_step_32_v6()
    })
    it('both fields valid: [GN: valid, FN: valid]', function () {
      element.childs_details_step_32_v7()
    })
  })
  context('[Child’s Details] Childs Email Validation Errors', function () {
    it('both feilds empty [GN: empty, FN: empty]', function () {
      element.childs_details_step_33_v1()
    })
    it('one field valid:[email: valid, cf-email: empty]', function () {
      element.childs_details_step_33_v2()
    })
    it('one field valid:[email: empty, cf-email: valid]', function () {
      element.childs_details_step_33_v3()
    })
    it('both fields invalid: [email: invalid, cf-email: invalid]', function () {
      element.childs_details_step_33_v4()
    })
    it('one field valid: [email: invalid, cf-email: valid]', function () {
      element.childs_details_step_33_v5()
    })
    it('one field valid: [email: valid, cf-email: invalid]]', function () {
      element.childs_details_step_33_v6()
    })
    it('both fields valid: [email: valid, cf-email: valid]', function () {
      element.childs_details_step_33_v7()
    })
  })
  context('[Child’s Details] Childs Phone Validation Errors', function () {
    it('both fields empty: [phone: empty, cf-phone: empty]', function () {
      element.childs_details_step_33_v8()
    })
    it('one field empty:[phone: valid, cf-phone: empty]', function () {
      element.childs_details_step_33_v9()
    })
    it('one field valid:[phone: empty, cf-phone: valid]', function () {
      element.childs_details_step_33_v10()
    })
    it('both fields invalid: [phone: invalid, cf-phone: invalid]', function () {
      element.childs_details_step_33_v11()
    })
    it('one field valid: [phone: invalid, cf-phone: valid]', function () {
      element.childs_details_step_33_v12()
    })
    it('one field valid: [phone: valid, cf-phone: invalid]', function () {
      element.childs_details_step_33_v13()
    })
    it('they cannot be contacted', function () {
      element.childs_details_step_33_v14()
    })
  })
  context('[Child’s Details] Childs DOB Validation Errors', function () {
    it('all fields empty: [D: empty, M: empty, Year: empty]', function () {
      element.childs_details_step_34_v1()
    })
    it('two fields empty', function () {
      element.childs_details_step_34_v2()
    })
    it('one fields empty', function () {
      element.childs_details_step_34_v3()
    })
    it('one field valid', function () {
      element.childs_details_step_34_v4()
    })
    it('two fields valid', function () {
      element.childs_details_step_34_v5()
    })
    it('all valid: future date [next year]', function () {
      element.childs_details_step_34_v6()
    })
    it('all valid: future date [tomorrrow]', function () {
      element.childs_details_step_34_v7()
    })
    it('all valid: past date [19 years old]', function () {
      element.childs_details_step_34_v8()
    })
    it('all valid: past date [18 years old]', function () {
      element.childs_details_step_34_v9()
    })
    it('all valid: past date [17 years old]', function () {
      element.childs_details_step_34_v10()
    })
  })
})  


