const element = require('../../pages/EOI/eoi_self_assessment_uhp')

describe('[Frontend-UI]: EOI SELF ASSESSMENT UNHAPPY PATH', function () {
  this.beforeEach(() => {
    cy.newSession()
    element.eoi_eligibility_check_start()
  })

  it('Verify self assessment', function () {
    element.eoi_eligibility_check_property_suitability()
    element.eoi_eligibility_check_imp_things()
    element.eoi_eligibility_check_hosting_6months()
    element.eoi_eligibility_check_need_information()
  })
})