const element = require('../../pages/UAM/uam_e2e_hp')
const eligibility = require('../../pages/UAM/uam_eli_uhp')

describe('[Frontend-UI]: UAM ELIGIBILITY [UNHAPPY PATH]', function () {
  this.beforeEach(() => {
    cy.newSession()
    cy.fixture('uam_appdata').then(function(uam_secrets){
      this.data = uam_secrets
    })
    eligibility.uam_eli_start()
  })

  it('verify eligibility UHP step 1', function () {
    eligibility.uam_eli_step_1()
  })
  it('verify eligibility UHP step 2', function () {
    eligibility.uam_eli_step_2()
  })
  it('verify eligibility UHP step 3', function () {
    eligibility.uam_eli_step_3()
  })
  it('verify eligibility UHP step 4', function () {
    eligibility.uam_eli_step_4()
  })
  it('verify eligibility UHP step 5', function () {
    eligibility.uam_eli_step_5()
  })
  it('verify eligibility UHP step 6', function () {
    eligibility.uam_eli_step_6()
  })
  it('verify eligibility UHP step 7', function () {
    eligibility.uam_eli_step_7()
  })
})
