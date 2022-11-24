const element = require('../../pages/EOI/cookie_journey_validation')

describe('[Frontend-UI]: EOI FORM ERROR LABEL VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Hide/Display Cookie banner', function () {
    it('displays the cookie banner on visit to website', function () {
      element.cookieDisplays()
    })

    it('hides the cookie banner when the user clicks "view cookies" on the banner', function () {
        element.cookieMessageDissapearsOnClickingViewCookies()
      })

    
      it('banner hidden on click "Go back to the page you were looking at" on cookies success page', function () {
        element.bannerHiddenOnReturningToPageYouWereLookingAt()
      })



  })



})






