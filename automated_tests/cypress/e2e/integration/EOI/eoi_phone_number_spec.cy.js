const element = require('../../pages/EOI/eoi_phone_number')

describe('[Frontend-UI]: EOI CONTACT TELEPHONE NUMBER', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
 // Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Contact Telephone Number Validation[Telephone Number Page : Invalid]', function () {
    it("phone number invalid [blank]", function () {
      element.phone_blank()
    })
    it("phone number invalid [letters]", function () {
      element.phone_letters()
    })
    it("phone number invalid [special characters]", function () {
      element.phone_special_characters()
    })
    it("phone number invalid [letters and special characters]", function () {
      element.phone_letters_special_characters()
    })
    it("phone number invalid [numbers and letters]", function () {
      element.phone_nums_letters()
    })
    it("phone number invalid [numbers and special characters]", function () {
      element.phone_nums_special_characters()
    })
    it("phone number invalid [numbers : 10 digits]", function () {
      element.phone_10_digits()
    })
    it("phone number invalid [numbers : 14 digits]", function () {
      element.phone_14_digits()
    })
    it("phone number invalid [numbers int format : (+) 10 digits]", function () {
      element.phone_10digits_plus()
    })
  })
  context('Contact Telephone Number Validation[Telephone Number Page : Valid]', function () {
    it("phone number valid [numbers : 11 digits]", function () {
      element.phone_11_digits()
    })
    it("phone number valid [numbers : 12 digits]", function () {
      element.phone_12_digits()
    })
    it("phone number valid [numbers : 13 digits]", function () {
      element.phone_13_digits()
    })
    it("phone number valid [numbers landline : 11 digits]", function () {
      element.phone_lndline()
    })
    it("phone number valid [numbers int format : (+) 12 digits ]", function () {
      element.phone_plus()
    })
  })
  context('Contact Telephone Number Validation[Telephone Number Error Page : Invalid]', function () {
    it("phone number invalid [letters and special characters]", function () {
      element.phone_err_special_charactors()
    })
    it("phone number invalid [numbers : 10 digits]", function () {
      element.phone_err_10_digits()
    })
    it("phone number invalid [numbers int format : (+) 10 digits]", function () {
      element.phone_err_10_digits_plus()
    })
  })
  context('Contact Telephone Number Validations[Telephone Number Error Page : Valid]', function () {
    it("phone number valid [numbers : 11 digits]", function () {
      element.phone_err_11_digits()
    })
    it("phone number valid [numbers landline : 11 digits]", function () {
      element.phone_err_landline()
    })
    it("phone number valid [numbers int format : (+) 12 digits ]", function () {
      element.phone_err_plus()
    })
  })
  this.afterAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})