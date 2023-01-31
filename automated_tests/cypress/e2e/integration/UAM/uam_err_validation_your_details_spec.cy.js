const element = require('../../pages/UAM/uam_err_validation_your_details')

describe('[Frontend-UI]: UAM ERROR VALIDATION [YOUR DETAILS]', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Eligibility Check', function () {
    it('verify eligibility', function () {
      element.uam_eligibility_step1_9()
    })
  })
  context('[Your Details] Sponsor Name', function () {
    it('name error validation [GN: empty, FN: empty]', function () {
      element.your_details_name_step_10_v1()
    })
    it('name error validation [GN: valid, FN: empty]', function () {
      element.your_details_name_step_10_v2()
    })
    it('name error validation [GN: empty, FN: valid]', function () {
      element.your_details_name_step_10_v3()
    })
    it('name error validation [GN: invalid, FN: invalid]', function () {
      element.your_details_name_step_10_v4()
    })
    it('name error validation [GN: invalid, FN: valid]', function () {
      element.your_details_name_step_10_v5()
    })
    it('name error validation [GN: valid, FN: invalid]', function () {
      element.your_details_name_step_10_v6()
    })
    it('name error validation [GN: valid, FN: valid]', function () {
      element.your_details_name_step_10_v7()
    })
  })
  context('[Your Details] Sponsor known by another name', function () {
    it('other name error validation [GN: empty, FN: empty]', function () {
      element.your_details_othername_step_12_v8()
    })
    it('other name error validation [GN: valid, FN: empty]', function () {
      element.your_details_othername_step_12_v9()
    })
    it('other name error validation [GN: empty, FN: valid]', function () {
      element.your_details_othername_step_12_v10()
    })
    it('other name error validation [GN: invalid, FN: invalid]', function () {
      element.your_details_othername_step_12_v11()
    })
    it('other name error validation [GN: invalid, FN: valid]', function () {
      element.your_details_othername_step_12_v12()
    })
    it('other name error validation [GN: valid, FN: invalid]', function () {
      element.your_details_othername_step_12_v13()
    })
    it('other name error validation [GN: valid, FN: valid]', function () {
      element.your_details_othername_step_12_v14()
    })
  })
  context('[Your Details] Sponsor contact details : Email', function () {
    it('email error validation [email: empty, cf-email: empty]', function () {
      element.your_details_contact_details_step_14_v1()
    })
    it('email error validation [email: valid, cf-email: empty]', function () {
      element.your_details_contact_details_step_14_v2()
    })
    it('email error validation [email: empty, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v3()
    })
    it('email error validation [email: invalid, cf-email: invalid]', function () {
      element.your_details_contact_details_step_14_v4()
    })
    it('email error validation [email: invalid, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v5()
    })
    it('email error validation [email: valid, cf-email: invalid]', function () {
      element.your_details_contact_details_step_14_v6()
    })
    it('email error validation [email: valid, cf-email: valid]', function () {
      element.your_details_contact_details_step_14_v7()
    })
  })
  context('[Your Details] Sponsor contact details : Phone', function () {
    it('phone error validation [mobile: empty, cf-mobile: empty]', function () {
      element.your_details_mobile_step_15_v1()
    })
    it('phone error validation [mobile: valid, cf-mobile: empty]', function () {
      element.your_details_mobile_step_15_v2()
    })
    it('phone error validation [mobile: empty, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v3()
    })
    it('phone error validation [mobile: invalid, cf-mobile: invalid]', function () {
      element.your_details_mobile_step_15_v4()
    })
    it('phone error validation [mobile: invalid, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v5()
    })
    it('phone error validation [mobile: valid, cf-mobile: invalid]', function () {
      element.your_details_mobile_step_15_v6()
    })
    it('phone error validation [mobile: valid, cf-mobile: valid]', function () {
      element.your_details_mobile_step_15_v7()
    })
  })

  context('[Your Details] Additional Details : DOB', function () {
    it('sponsor dob validation [All feilds empty]', function () {
      element.your_details_ad_details_dob_step_18_v1()
    })
    it('sponsor dob validation [two feilds empty]', function () {
      element.your_details_ad_details_dob_step_18_v2()
    })
    it('sponsor dob validation [one feild empty]', function () {
      element.your_details_ad_details_dob_step_18_v3()
    })
    it('sponsor dob validation [future date]', function () {
      element.your_details_ad_details_dob_step_18_v4('2050')
    })
    it('sponsor dob validation [past date (1 year ago)]', function () {
      element.your_details_ad_details_dob_step_18_v5('2022')
    })
    it('sponsor dob validation [past date (17 year ago)]', function () {
      element.your_details_ad_details_dob_step_18_v6('2005')
    })
    it('sponsor dob validation [past date (18+ year ago)]', function () {
      element.your_details_ad_details_dob_step_18_v7('2004')
    })
  })
})






