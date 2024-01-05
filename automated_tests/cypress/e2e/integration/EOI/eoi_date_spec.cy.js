const element = require('../../pages/EOI/eoi_date')

describe('[Frontend-UI]: EOI DATE', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Specific Date Validations', function () {
    it("date error validations [all fields blank]", function () {
      element.date_null()
    })
    it("date error validations [one feild filled 'dd/mm/yyyy']", function () {
      element.date_v1()
    })
    it("date error validations [two feilds filled 'dd/mm/yyyy']", function () {
      element.date_v2()
    })
    it("date error validations [invalid date, '31-02-2023']", function () {
      element.date_v3()
    })
    it("date error validations [invalid date, 'yesterday']", function () {
      element.date_v4()
    })
    it("date error validations [invalid day, '35']", function () {
      element.date_v5()
    })
    it("date error validations [invalid month, '18']", function () {
      element.date_v6()
    })
    it("date error validations [invalid month, '500']", function () {
      element.date_v7()
    })
    it("date error validations [all feilds invalid, '32-13--2023']", function () {
      element.date_ai()
    })
    it("date error validations [all feilds valid, 'todays date']", function () {
      element.date_av()
    })
    it("date error validations [all feilds valid, 'future date']", function () {
      element.date_fu()
    })
  })
})