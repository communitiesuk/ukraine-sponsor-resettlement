const alfa = require('../../pages/Service/cookies')

describe('[Frontend-UI]: COOKIES PAGE', function () {
  context('Cookies Page', function () {
    it('back_to link', function () {
      alfa.eoi_cookies_page_back_link()
    })
  })
  context('Hide/Display Cookie banner', function () {
    it('displays the cookie banner on visit to website', function () {
      alfa.cookie_displays()
    })
    it('cookie banner displays when the user clicks on "view cookies"', function () {
      alfa.cookie_message_dissappears_after_clicking_view_cookies()
    })
    it('banner hidden on click "Go back to the page you were looking at" on cookies success page', function () {
      alfa.banner_hidden_after_clicking_goback_to_page_link()
    })
  })
})
