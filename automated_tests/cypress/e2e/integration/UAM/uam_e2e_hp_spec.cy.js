const element = require('../../pages/UAM/uam_eligibility')
const tasklist = require('../../pages/UAM/uam_e2e_hp')

describe('[Frontend-UI]: UAM E2E JOURNEY [HAPPY PATH]', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function(uam_secrets){
      this.data = uam_secrets
    })
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
  context('[Frontend-UI] Tasklist ', function () {
    it('verify tasklist page details', function () {
      tasklist.uam_tasklist_page()
    })
  })
  context('[Frontend-UI] Your details ', function () {
    it('verify your name', function () {
      tasklist.your_details_name_step_10()
    })
    it('verify known by another name', function () {
      tasklist.your_details_othername_step_11()
    })
    it('verify add your other name', function () {
      tasklist.your_details_othername_step_12()
    })
    it('verify added name', function () {
      tasklist.your_details_othername_step_13()
    })
    it('verify contact details page', function () {
      tasklist.your_details_contact_details_step_14()
    })
    it('verify mobile number', function () {
      tasklist.your_details_mobile_step_15()
    })
    it('verify ID', function () {
      tasklist.your_details_additional_details_step_16()
    })
    it('verify DOB', function () {
      tasklist.your_details_additional_details_step_18()
    })
    it('verify nationality', function () {
      tasklist.your_details_additional_details_step_19()
    })
    it('verify other nationalities', function () {
      tasklist.your_details_additional_details_step_20()
      tasklist.your_details_additional_details_step_21()
      tasklist.your_details_additional_details_step_22()
    })
    it('verify completed 1 of 4', function () {
      tasklist.verify_completed_tasks_1_of_4()
    })
  })
  context('[Frontend-UI] Verify Child’s accommodation ', function () {
    it('verify childs address', function () {
      tasklist.childs_accommodation_step_23()
    })
    it('verify the sponsor be living at this address? page', function () {
      tasklist.childs_accommodation_step_24()
    })
    it('verify sponsors address', function () {
      tasklist.childs_accommodation_step_26()
    })
    it('verify over 16 who will live with the child', function () {
      tasklist.childs_accommodation_step_27()
    })
    it('verify added person over 16', function () {
      tasklist.childs_accommodation_step_28()
    })
    it('verify completed 2 of 5', function () {
      tasklist.verify_completed_tasks_2_of_5()
    })
  })
  context('[Frontend-UI] Residents details(over 16) ', function () {
    it('verify person over 16 DOB', function () {
      tasklist.residents_details_step29()
    })
    it('verify person over 16 nationality', function () {
      tasklist.residents_details_step30()
    })
    it('verify person over 16 ID documents', function () {
      tasklist.residents_details_step31()
    })
    it('verify completed 3 of 5', function () {
      tasklist.verify_completed_tasks_3_of_5()
    })
  })
  context('[Frontend-UI] Childs details ', function () {
    it('verify childs name', function () {
      tasklist.childs_details_step_32()
    })
    it('verify childs contact details', function () {
      tasklist.childs_details_step_33()
    })
    it('verify childs DOB', function () {
      tasklist.childs_details_step_34()
    })
    it('verify consent form', function () {
      tasklist.consent_form_step_35()
    })
    it('verify consent form upload', function () {
      tasklist.consent_form_step_36()
    })
    it('verify ukrainian consent form upload', function () {
      tasklist.ukrconsent_form_step_37()
    })
    it('verify completed tasks 4 of 5', function () {
      tasklist.verify_completed_tasks_4_of_5()
    })
  })
  context('[Frontend-UI] Send application ', function () {
    it('verify use data [confirmation]', function () {
      tasklist.confirmation_page_step_38()
    })
    it('verify eligibility [confirmation]', function () {
      tasklist.confirmation_page_step_39()
    })
    it('verify check answers', function () {
      tasklist.check_answers()
    })
    it('verify send application', function () {
      tasklist.accept_send()
    })
  })
})






