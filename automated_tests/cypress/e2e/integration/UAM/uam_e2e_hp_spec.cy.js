const element = require('../../pages/UAM/uam_e2e_hp')
const eligibility = require('../../pages/UAM/eligibility')

describe('[Frontend-UI]: UAM E2E JOURNEY [HAPPY PATH]', function () {
  this.beforeAll(() => {
    cy.newSession()
    cy.fixture('uam_appdata').then(function(uam_secrets){
      this.data = uam_secrets
    })
  })

  context('Eligibility Check', function () {
    it('verify eligibility for sponsor a child', function () {
      eligibility.uam_eligibility_steps()
    })
  })
  context('Tasklist ', function () {
    it('verify tasklist page details', function () {
      element.uam_tasklist_page()
    })
  })
  context('Your details ', function () {
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
    it('verify completed 1 of 4', function () {
      element.verify_completed_tasks_1_of_4()
    })
  })
  context('Verify Child’s accommodation ', function () {
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
    it('verify completed 2 of 5', function () {
      element.verify_completed_tasks_2_of_5()
    })
  })
  context('Residents details(over 16) ', function () {
    it('verify person over 16 DOB', function () {
      element.residents_details_step29()
    })
    it('verify person over 16 nationality', function () {
      element.residents_details_step30()
    })
    it('verify person over 16 ID documents', function () {
      element.residents_details_step31()
    })
    it('verify completed 3 of 5', function () {
      element.verify_completed_tasks_3_of_5()
    })
  })
  context('Childs details ', function () {
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
    it('verify completed tasks 4 of 5', function () {
      element.verify_completed_tasks_4_of_5()
    })
  })
  context('Send application ', function () {
    it('verify use data [confirmation]', function () {
      element.confirmation_page_step_38()
    })
    it('verify eligibility [confirmation]', function () {
      element.confirmation_page_step_39()
    })
    it('verify check answers', function () {
      element.check_answers()
    })
    it('verify send application', function () {
      element.accept_send()
    })
  })
})
