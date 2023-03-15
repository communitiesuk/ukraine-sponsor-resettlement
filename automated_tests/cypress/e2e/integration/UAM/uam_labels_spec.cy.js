const element = require('../../pages/UAM/uam_labels')

describe('[Frontend-UI]: UAM LABELS', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Eligibility Check Error Labels', function () {
    it('verify eligibility error labels', function () {
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
  context('Your Details Error Labels ', function () {
    it('verify your name error labels', function () {
      element.your_details_name_step_10()
    })
    it('verify known by another name error labels', function () {
      element.your_details_othername_step_11()
    })
    it('verify add your other name error labels', function () {
      element.your_details_othername_step_12()
    })
    it('verify added name error labels', function () {
      element.your_details_othername_step_13()
    })
    it('verify contact details error labels', function () {
      element.your_details_contact_details_step_14()
    })
    it('verify mobile number error labels', function () {
      element.your_details_mobile_step_15()
    })
    it('verify ID error labels', function () {
      element.your_details_additional_details_step_16()
    })
    it('prove ID error labels', function () {
      element.your_details_prove_id_step_17()
    })
    it('verify DOB error labels', function () {
      element.your_details_additional_details_step_18()
    })
    it('verify nationality error labels', function () {
      element.your_details_additional_details_step_19()
    })
    it('verify other nationalities error labels', function () {
      element.your_details_additional_details_step_20()
      element.your_details_additional_details_step_21()
      element.your_details_additional_details_step_22()
    })
  })
  context('Verify Child’s accommodation Error Labels ', function () {
    it('verify childs address error labels', function () {
      element.childs_accommodation_step_23()
    })
    it('verify the sponsor be living at this address? page error labels', function () {
      element.childs_accommodation_step_24()
    })
    it('verify sponsors address error labels', function () {
      element.childs_accommodation_step_26()
    })
    it('verify over 16 who will live with the child error labels', function () {
      element.childs_accommodation_step_27()
    })
    it('verify added person over 16 error labels', function () {
      element.childs_accommodation_step_28()
    })
  })
  context('Residents Details(over 16) Error Labels', function () {
    it('verify person over 16 DOB error labels', function () {
      element.residents_details_step29()
    })
    it('verify person over 16 nationality error labels', function () {
      element.residents_details_step30()
    })
    it('verify person over 16 ID documents error labels', function () {
      element.residents_details_step31()
    })
  })
  context('Childs Details Error Labels ', function () {
    it('verify childs name error labels', function () {
      element.childs_details_step_32()
    })
    it('verify childs contact details error labels', function () {
      element.childs_details_step_33()
    })
    it('verify childs DOB error labels', function () {
      element.childs_details_step_34()
    })
    it('verify consent form error labels', function () {
      element.consent_form_step_35()
    })
    it('verify consent form upload error labels', function () {
      element.consent_form_step_36()
    })
    it('verify ukrainian consent form upload error labels', function () {
      element.ukrconsent_form_step_37()
    })
  })
  context('Send application Error Labels ', function () {
    it('verify use data [confirmation] error labels', function () {
      element.confirmation_page_step_38()
    })
    it('verify eligibility [confirmation] error labels', function () {
      element.confirmation_page_step_39()
    })
    it('verify check answers error labels', function () {
      element.check_answers()
    })
  })
})