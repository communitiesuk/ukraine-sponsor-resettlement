const element = require('../../pages/EOI/eoi_backlink')

describe('[Frontend-UI]: EOI BACKLINK VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Self Assessment', function () {
    it('verify suitable for hosting page [back link : P1 - 2]', function () {
      element.eoi_eligibility_check_p1_2()
    })
    it('verify things to consider page [back link : P2 - 3]', function () {
      element.eoi_eligibility_check_p2_3()
    })
    it('verify at least 6 months page [back link : P3 - 4]', function () {
      element.eoi_eligibility_check_p3_4()
    })
    it('verify need your information page [back link : P4 - 5]', function () {
      element.eoi_eligibility_check_p4_5()
    })
  })
  context('Registration', function () {
    it('verify details full name page [back link : step 1]', function () {
      element.your_details_name_s1()
    })
    it('verify details email page [back link : step 2]', function () {
      element.your_details_email_s2()
    })
    it('verify details phone no page [back link : step 3]', function () {
      element.your_details_phone_s3()
    })
    it('verify residential address page [back link : step 4]', function () {
      element.your_details_resaddress_s4()
    })
    it('verify different address to your home page [back link : step 5]', function () {
      element.dif_address_to_your_home_s5()
    })
    it('verify offering property address page [back link : step 6]', function () {
      element.offering_property_address_s6()
    })
    it('verify any more properties page [back link : step 7]', function () {
      element.any_more_properties_s7()
    })
    it('verify share information about any more properties page [back link : step 8]', function () {
      element.share_info_more_properties_s8()
    })
    it('verify start hosting someone page [back link : step 9]', function () {
      element.hosting_someone_s9()
    })
    it('verify How many people page [back link : step 10]', function () {
      element.how_many_people_s10()
    })
    it('verify offer accommodation to page [back link : step 11]', function () {
      element.offer_accommodation_to_s11()
    })
    it('verify How many bedrooms page [back link : step 12]', function () {
      element.bedroom_details_s12()
    })
    it('verify step-free access page [back link : step 13]', function () {
      element.stepfree_access_s13()
    })
    it('verify pets page [back link : step 14]', function () {
      element.pets_s14()
    })
    it('verify take part in research page [back link : step 15]', function () {
      element.take_part_in_research_s15()
    })
    it('verify consent page [back link : step 16]', function () {
      element.consent_s16()
    })
    it('verify Check your answers page [back link : step 17]', function () {
      element.check_your_answers_s17()
    })
  })
})