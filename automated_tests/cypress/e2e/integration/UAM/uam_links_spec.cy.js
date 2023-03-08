const element = require('../../pages/UAM/uam_links')

describe('[Frontend-UI]: UAM LINKS [Validation]', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
    cy.fixture('uam_appdata').then(function (uam_secrets) {
      this.data = uam_secrets
    })
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('[main page links]', function () {
    it('guidance for sponsoring a child fleeing Ukraine link', function () {
      element.uam_main_page_guidance()
    })
    it('UK sponsorship arrangement consent form link', function () {
      element.uam_main_spon_consent()
    })
    it('find out how to complete the consent forms link', function () {
      element.uam_main_fo_comp_consent()
    })
    it('read the guidance for children applying for a visa without a parent or legal guardian link', function () {
      element.uam_main_gui_apply_visa()
    })
    it('open government licence v3.0 link', function () {
      element.uam_gov_lic()
    })
    it('crown copyright link', function () {
      element.uam_crown_copyright()
    })
    it('apply to provide a safe home for a child from Ukraine link', function () {
      element.uam_main_page_apply()
    })
  })
  context('[start page links]', function () {
    it('continue a saved application link', function () {
      element.uam_start_page_cont()
    })
    it('start new application link', function () {
      element.uam_start_page_newapp()
    })
    it('guidance for sponsoring a child fleeing Ukraine link', function () {
      element.uam_start_page_guidance()
    })
    it('UK sponsorship arrangement consent form link', function () {
      element.uam_start_page_spon_consent()
    })
  })
  context('[cannot use this service page links]', function () {
    it('go back to the previous page link', function () {
      element.uam_cannot_uts_prev()
    })
    it('sponsor a family member from Ukraine link', function () {
      element.uam_cannot_uts_spon_fam()
    })
    it('sponsor someone you already know from Ukraine link', function () {
      element.uam_cannot_uts_spon_alknow()
    })
    it('register your interest with Homes for Ukraine link', function () {
      element.uam_cannot_uts_register()
    })
    it('register your interest with Homes for Ukraine link', function () {
      element.uam_step_5()
    })
  })
  context('[all other page links]', function () {
    it('read guidance about which consent forms are required link [step 5]', function () {
      element.uam_step_5()
    })
    it('what is the minimum period? link [step 6, step 7]', function () {
      element.uam_step_6()
    })
    it("I'm not sure how to enter my name link [step 10 link 1]", function () {
      element.uam_step_10_l1()
    })
    it("save and return later link [step 10 link 2]", function () {
      element.uam_step_10_l2()
    })
    it("I'm not sure how to enter my name link [step 12]", function () {
      element.uam_step_12()
    })
    it("remove link [step 13]", function () {
      element.uam_step_13()
    })
    it("remove link [step 22]", function () {
      element.uam_step_22()
    })
    it("who counts as 'living at this address'? link [step 25]", function () {
      element.uam_step_25()
    })
    it("I'm not sure how to enter their name link [step 27]", function () {
      element.uam_step_27()
    })
    it("I'm not sure how to enter their name link [step 32]", function () {
      element.uam_step_32()
    })
    it("UK sponsorship arrangement consent form link [step 35 link 1]", function () {
      element.uam_step_35_l1()
    })
    it("read guidance about parental consent forms. link [step 35 link 2]", function () {
      element.uam_step_35_l2()
    })
    it("I need help link [step 36 link 1]", function () {
      element.uam_step_36_l1()
    })
    it("read the guidance on completing parental consent forms. link [step 36 link 2]", function () {
      element.uam_step_36_l2()
    })
    it("I need help link [step 37 link 1]", function () {
      element.uam_step_37_l1()
    })
    it("read the guidance on completing parental consent forms. link [step 37 link 2]", function () {
      element.uam_step_37_l2()
    })
    it("privacy statement link [step 38]", function () {
      element.uam_step_38()
    })
    it("guidance for sponsoring a child fleeing Ukraine. link [step 39]", function () {
      element.uam_step_39()
    })
    it("Read the guidance on sponsoring a child from Ukraine link [step confirm link 1]", function () {
      element.uam_step_confirm_l1()
    })
    it("complete another application link [step confirm link 2]", function () {
      element.uam_step_confirm_l2()
    })
  })
  context('[check your answers page links]', function () {
    it("all the links [change]", function () {
      element.uam_check_your_answers()
    })

  })
})



