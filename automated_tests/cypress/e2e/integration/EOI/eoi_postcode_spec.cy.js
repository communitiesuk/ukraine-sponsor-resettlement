const alfa = require('../../pages/EOI/eoi_postcode')

describe('[Frontend-UI]: EOI POSTCODE VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Postcode Validation: Residential Address Scotland', function () {
    it('postcode validation [Residential Add: Scot/Glasgow, Offering Add: Same Address]', function () {
      alfa.postcode_validation_scot_same()
    })
    it('postcode validation [Residential Add: Scot/Glasgow, Offering Add: Scot/Glasgow]', function () {
      alfa.postcode_validation_scot_scot()
    })
    it('postcode validation [Residential Add: Scot/Glasgow, Offering Add: Wales/Cwmbran]', function () {
      alfa.postcode_validation_scot_wales()
    })
    it('postcode validation [Residential Add: Scot/Glasgow, Offering Add: England/London ]', function () {
      alfa.postcode_validation_scot_eng()
    }) 
  })
  context('Postcode Validation: Residential Address Wales', function () {
    it('postcode validation [Residential Add: Wales/Broughton, Offering Add: Same Address]', function () {
      alfa.postcode_validation_wales_same()
    })
    it('postcode validation [Residential Add: Wales/Broughton, Offering Add: Wales/Swan]', function () {
      alfa.postcode_validation_wales_wales()
    })
    it('postcode validation [Residential Add: Wales/Broughton, Offering Add: Scotland/Edin]', function () {
      alfa.postcode_validation_wales_scot()
    })
    it('postcode validation [Residential Add: Wales/Broughton, Offering Add: England/Sheffield ]', function () {
      alfa.postcode_validation_wales_eng()
    })
  })
  context('Postcode Validation: Residential Address England', function () {
    it('postcode validation [Residential Add: England/London, Offering Add: Same Address]', function () {
      alfa.postcode_validation_eng_same()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Eng/Plymouth]', function () {
      alfa.postcode_validation_eng_eng()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Scotland/Aberdeen]', function () {
      alfa.postcode_validation_eng_scot()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Wales/Newport]', function () {
      alfa.postcode_validation_eng_wales()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Scotland/Eyemouth', function () {
      alfa.postcode_validation_eng_scot_eyem()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Scotland/Newcastleton', function () {
      alfa.postcode_validation_eng_scot_newc()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Wales/Holyhead]', function () {
      alfa.postcode_validation_eng_wales_holyh()
    })
    it('postcode validation [Residential Add: England/London, Offering Add: Wales/Pembroke]', function () {
      alfa.postcode_validation_eng_wales_pemb()
    })
  })
  this.afterAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})