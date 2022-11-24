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

  context('Hide/Display Cookie banner', function () {
    it('displays the cookie banner on visit to website', function () {
      alfa.cookie_displays()
    })

    it('hides the cookie banner when the user clicks "view cookies" on the banner', function () {
        alfa.cookie_message_dissappears_after_clicking_view_cookies()
      })

    
    it('banner hidden on click "Go back to the page you were looking at" on cookies success page', function () {
        alfa.banner_hidden_after_clicking_goback_to_page_link()
      })

  })

  this.afterEach(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})
