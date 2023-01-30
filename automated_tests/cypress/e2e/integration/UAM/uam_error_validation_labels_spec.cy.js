const element = require('../../pages/UAM/uam_error_validation_labels')

describe('[Frontend-UI]: UAM E2E JOURNEY [HAPPY PATH]', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function(uam_secrets){this.data = uam_secrets})
    cy.fixture('uam_bodytext_err').then(function(uam_bt_err){this.data = uam_bt_err})
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('[Frontend-UI] Eligibility Check', function () {
    it('verify eligibility for sponcer a child', function () {
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
  context('[Frontend-UI] Your details ', function () {
    it('verify your name', function () {
      element.your_details_name_step_10()
    })
    it('verify known by another name', function () {
      element.your_details_othername_step_11()
    })
    it('verify add your other name', function () {
      element.your_details_othername_step_12()
    })
    it('verify added name', function () {
      element.your_details_othername_step_13()
    })
    it('verify contact details page', function () {
      element.your_details_contact_details_step_14()
    })
    it('verify mobile number', function () {
      element.your_details_mobile_step_15()
    })
    it('verify ID', function () {
      element.your_details_additional_details_step_16()
    })
    it('prove ID', function () {
      element.your_details_prove_id_step_17()
    })
    it('verify DOB', function () {
      element.your_details_additional_details_step_18()
    })
    it('verify nationality', function () {
      element.your_details_additional_details_step_19()
    })
    it('verify other nationalities', function () {
      element.your_details_additional_details_step_20()
      element.your_details_additional_details_step_21()
      element.your_details_additional_details_step_22()
    })
  })
  context('[Frontend-UI] Verify Child’s accommodation ', function () {
    it('verify childs address', function () {
      element.childs_accommodation_step_23()
    })
    it('verify the sponsor be living at this address? page', function () {
      element.childs_accommodation_step_24()
    })
    it('verify sponsors address', function () {
      element.childs_accommodation_step_26()
    })
    it('verify over 16 who will live with the child', function () {
      element.childs_accommodation_step_27()
    })
    it('verify added person over 16', function () {
      element.childs_accommodation_step_28()
    })
  })
  context('[Frontend-UI] Residents details(over 16) ', function () {
    it('verify person over 16 DOB', function () {
      element.residents_details_step29()
    })
    it('verify person over 16 nationality', function () {
      element.residents_details_step30()
    })
    it('verify person over 16 ID documents', function () {
      element.residents_details_step31()
    })
  })
  context('[Frontend-UI] Childs details ', function () {
    it('verify childs name', function () {
      element.childs_details_step_32()
    })
    it('verify childs contact details', function () {
      element.childs_details_step_33()
    })
    it('verify childs DOB', function () {
      element.childs_details_step_34()
    })
    it('verify consent form', function () {
      element.consent_form_step_35()
    })
    it('verify consent form upload', function () {
      element.consent_form_step_36()
    })
    it('verify ukrainian consent form upload', function () {
      element.ukrconsent_form_step_37()
    })
  })
  context('[Frontend-UI] Send application ', function () {
    it('verify use data [confirmation]', function () {
      element.confirmation_page_step_38()
    })
    it('verify eligibility [confirmation]', function () {
      element.confirmation_page_step_39()
    })
    it('verify check answers', function () {
      element.check_answers()
    })
  })
})






