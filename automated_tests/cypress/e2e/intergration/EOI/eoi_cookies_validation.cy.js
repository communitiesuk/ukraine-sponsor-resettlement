const alfa = require('../../pages/EOI/cookies_validation')

describe('[Frontend-UI]: COOKIES PAGE', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Cookies Page', function () {
    it('back_to link', function () {
      alfa.eoi_cookies_page_back_link()
    })
  })

  this.afterAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})
