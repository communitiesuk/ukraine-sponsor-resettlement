const element = require('../../pages/EOI/links_validation')

describe('[Frontend-UI]: EOI PAGE LINKS VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Self Assessment', function () {
    it('Page links validation [Page 1: guidance]', function () {
     element.links_validation_sa_p1_guidance()
    })
    it('Page links validation [Page 1: government licence]', function () {
      element.links_validation_sa_p1_govlicence()
    })
    it('Page links validation [Page 1: crown copyright]', function () {
      element.links_validation_sa_p1_crown_copyright()
    })
    it('Page links validation [Other ways you can help page: local council]', function () {
      element.links_validation_sa_other_ways_l1()
    })
    it('Page links validation [Other ways you can help page: stand with ukraine]', function () {
      element.links_validation_sa_other_ways_l2()
    })
    it('Page links validation [Other ways you can help page: community sponsorship]', function () {
      element.links_validation_sa_other_ways_l3()
    })
    it('Page links validation [Other ways you can help page: volunteer]', function () {
      element.links_validation_sa_other_ways_l4()
    })
    it('Page links validation [Other ways you can help page: support these organisations]', function () {
      element.links_validation_sa_other_ways_l5()
    })
  })

  context('Registration', function () {
    it('Page links validation [steps 16: privacy statement]', function () {
      element.links_validation_step_16()
    })
  })

  this.afterAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})






