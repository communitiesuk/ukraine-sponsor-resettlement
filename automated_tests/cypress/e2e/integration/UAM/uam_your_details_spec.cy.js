const element = require('../../pages/UAM/uam_your_details')

describe('[Frontend-UI]: UAM YOUR DETAILS [SPONSOR]', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function (uam_secrets) { this.data = uam_secrets })
    cy.fixture('uam_bodytext_err').then(function (uam_bt_err) { this.data = uam_bt_err })
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Eligibility Check', function () {
    it('verify eligibility', function () {
      element.uam_eligibility_step1_9()
    })
  })
  context('[Your Details] Sponsor Name', function () {
    it('name: validation errors [GN: empty, FN: empty]', function () {
      element.your_details_name_step_10_v1()
    })
    it('name: validation errors [GN: valid, FN: empty]', function () {
      element.your_details_name_step_10_v2()
    })
    it('name: validation errors [GN: empty, FN: valid]', function () {
      element.your_details_name_step_10_v3()
    })
    it('name: validation errors [GN: invalid, FN: invalid]', function () {
      element.your_details_name_step_10_v4()
    })
    it('name: validation errors [GN: invalid, FN: valid]', function () {
      element.your_details_name_step_10_v5()
    })
    it('name: validation errors [GN: valid, FN: invalid]', function () {
      element.your_details_name_step_10_v6()
    })
    it('name: validation errors [GN: valid, FN: valid]', function () {
      element.your_details_name_step_10_v7()
    })
  })
  context('[Your Details] Sponsor known by another name', function () {
    it('other name: validation errors [GN: empty, FN: empty]', function () {
      element.your_details_othername_step_12_v8()
    })
    it('other name: validation errors [GN: valid, FN: empty]', function () {
      element.your_details_othername_step_12_v9()
    })
    it('other name: validation errors [GN: empty, FN: valid]', function () {
      element.your_details_othername_step_12_v10()
    })
    it('other name: validation errors [GN: invalid, FN: invalid]', function () {
      element.your_details_othername_step_12_v11()
    })
    it('other name: validation errors [GN: invalid, FN: valid]', function () {
      element.your_details_othername_step_12_v12()
    })
    it('other name: validation errors [GN: valid, FN: invalid]', function () {
      element.your_details_othername_step_12_v13()
    })
    it('other name: validation errors [GN: valid, FN: valid]', function () {
      element.your_details_othername_step_12_v14()
    })
  })
  context('[Your Details] Sponsor contact details : Email', function () {
    it('email: validation errors [email: empty, cf-email: empty]', function () {
      element.your_details_contact_details_step_14_v1()
    })
    it('email: validation errors [email: valid, cf-email: empty]', function () {
      element.your_details_contact_details_step_14_v2()
    })
    it('email: validation errors [email: empty, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v3()
    })
    it('email: validation errors [email: invalid, cf-email: invalid]', function () {
      element.your_details_contact_details_step_14_v4()
    })
    it('email: validation errors [email: invalid, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v5()
    })
    it('email: validation errors [email: valid, cf-email: invalid]', function () {
      element.your_details_contact_details_step_14_v6()
    })
    it('email: validation errors [email: valid, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v7()
    })
  })
  context('[Your Details] Sponsor contact details : Phone', function () {
    it('phone: validation errors [mobile: empty, cf-mobile: empty]', function () {
      element.your_details_mobile_step_15_v1()
    })
    it('phone: validation errors [mobile: valid, cf-mobile: empty]', function () {
      element.your_details_mobile_step_15_v2()
    })
    it('phone: validation errors [mobile: empty, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v3()
    })
    it('phone: validation errors [mobile: invalid, cf-mobile: invalid]', function () {
      element.your_details_mobile_step_15_v4()
    })
    it('phone: validation errors [mobile: invalid, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v5()
    })
    it('phone: validation errors [mobile: valid, cf-mobile: invalid]', function () {
      element.your_details_mobile_step_15_v6()
    })
    it('phone: validation errors [mobile: valid, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v7()
    })
  })
  context('[Your Details] Additional Details : ID', function () {
    it('sponsor ID [none selected]', function () {
      element.your_details_ad_details_id_step_16_v1()
    })
    it('sponsor ID [validation errors: passport]', function () {
      element.your_details_ad_details_id_step_16_v2()
    })
    it('sponsor ID [validation errors: national ID]', function () {
      element.your_details_ad_details_id_step_16_v3()
    })
    it('sponsor ID [validation errors: Biometric residence]', function () {
      element.your_details_ad_details_id_step_16_v4()
    })
    it('sponsor ID [validation errors: I dont have any of these]', function () {
      element.your_details_ad_details_id_step_16_v5()
    })
  })
  context('[Your Details] Additional Details : DOB', function () {
    it('sponsor dob: validation errors [All feilds empty]', function () {
      element.your_details_ad_details_dob_step_18_v1()
    })
    it('sponsor dob: validation errors [two feilds empty]', function () {
      element.your_details_ad_details_dob_step_18_v2()
    })
    it('sponsor dob: validation errors [one feild empty]', function () {
      element.your_details_ad_details_dob_step_18_v3()
    })
    it('sponsor dob: validation errors [future date]', function () {
      element.your_details_ad_details_dob_step_18_v4()
    })
    it('sponsor dob: validation errors [past date (1 year)]', function () {
      element.your_details_ad_details_dob_step_18_v5()
    })
    it('sponsor dob: validation errors [past date (17 years)]', function () {
      element.your_details_ad_details_dob_step_18_v6()
    })
    it('sponsor dob: validation errors [past date (18+ years)]', function () {
      element.your_details_ad_details_dob_step_18_v7()
    })
  })
})