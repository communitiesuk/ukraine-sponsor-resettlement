require('cypress-xpath');
const secrets = require('../../../fixtures/uam_appdata.json')
const elements = require('../../page_elements/UAM/uam_elements')
const bt_err = require('../../../fixtures/uam_bodytext_err.json')

//*******Child’s accommodation**************Child’s accommodation**************Child’s accommodation**************Child’s accommodation**************
const click_continue = () => { cy.get(elements.continue_button).click().wait(Cypress.env('waitTime')) }
const all_sbox_fields_err = () => {
    sbox_title()
    cy.xpath(elements.step23_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.xpath(elements.step23_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.xpath(elements.step23_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const all_fields_err = () => {
    cy.get(elements.step23_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step23_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step23_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const page_heading = () => {
    cy.get(elements.page_heading).contains('Enter the address where the child will be living in the UK').should('be.visible')
}
const adl1_err = () => {
    sbox_title()
    cy.xpath(elements.step23_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step23_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
}
const city_err = () => {
    sbox_title()
    cy.xpath(elements.step23_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step23_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
}
const pc_err = () => {
    sbox_title()
    cy.xpath(elements.step23_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
    cy.get(elements.step23_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const adl1_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step23_addr_sbox_err_msg).should('not.exist')
    cy.get(elements.step23_addr_err_msg).should('not.exist')
}
const city_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step23_city_sbox_err_msg).should('not.exist')
    cy.get(elements.step23_city_err_msg).should('not.exist')
}
const pc_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step23_pc_sbox_err_msg).should('not.exist')
    cy.get(elements.step23_pc_err_msg).should('not.exist')
}
//all fields empty [AL1: empty, AL2: empty, TC:empty: PC: empty]
export const childs_accommodation_step_23_v1 = () => {
    cy.visit('/sponsor-a-child/steps/23')
    page_heading()
    click_continue()
    all_sbox_fields_err()
    all_fields_err()
}
//one field empty [AL1: empty, TC:valid, PC: valid]
export const childs_accommodation_step_23_v2 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear()
    cy.get(elements.step23_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err_nv()
}
//one field empty [AL1: valid, TC:empty, PC: valid]
export const childs_accommodation_step_23_v3 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_textbox).clear()
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err_nv()
}
//one field empty [AL1: valid, TC: valid, PC: empty]
export const childs_accommodation_step_23_v4 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear()
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err_nv()
}
//two fields empty  [AL1: valid, TC:empty, PC: empty]
export const childs_accommodation_step_23_v5 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear()
    cy.get(elements.step23_pc_textbox).clear()
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err()
}
//two fields empty [AL1: empty, TC:valid, PC: empty]
export const childs_accommodation_step_23_v6 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear()
    cy.get(elements.step23_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear()
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err()
}
//two fields empty[AL1: empty, TC: empty, PC:valid]
export const childs_accommodation_step_23_v7 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear()
    cy.get(elements.step23_city_textbox).clear()
    cy.get(elements.step23_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err()
    pc_err_nv()
}
//one field valid [AL1: valid, TC: invalid, PC: invalid] {Requirement: Three characters minimum for addr.l1 & city}
export const childs_accommodation_step_23_v8 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear().type('A')
    cy.get(elements.step23_pc_textbox).clear().type('*** ***')
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear().type('XY')
    cy.get(elements.step23_pc_err_textbox).clear().type('123 456')
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err()
}
//one field valid [AL1: invalid, TC: valid, PC: invalid]
export const childs_accommodation_step_23_v9 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear().type('X')
    cy.get(elements.step23_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear().type('ABC XYZ')
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type('AB')
    cy.get(elements.step23_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear().type('RM8 1')
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err()
}
//one field valid [AL1: invalid, TC: invalid, PC: valid]
export const childs_accommodation_step_23_v10 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type('£')
    cy.get(elements.step23_city_textbox).clear().type('[]')
    cy.get(elements.step23_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err()
    pc_err_nv()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type('##')
    cy.get(elements.step23_city_err_textbox).clear().type('$$')
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err()
    pc_err_nv()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type('1')
    cy.get(elements.step23_city_err_textbox).clear().type('2')
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err()
    pc_err_nv()
}
//two fields valid [AL1: valid, TC: valid, PC: invalid]
export const childs_accommodation_step_23_v11 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_textbox).clear().type('NW10 1A')
    click_continue()
    adl1_err_nv()
    city_err_nv()
    pc_err()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear().type('GW10 1A+')
    click_continue()
    adl1_err_nv()
    city_err_nv()
    pc_err()
}
//two fields valid [AL1: invalid, TC: valid, PC: valid]
export const childs_accommodation_step_23_v12 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear().type('22')
    cy.get(elements.step23_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err_nv()

    cy.get(elements.step23_addr_line1_err_textbox).clear().type('0+')
    cy.get(elements.step23_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err()
    city_err_nv()
    pc_err_nv()
}
//two fields valid [AL1: valid, TC: invalid, PC: valid]
export const childs_accommodation_step_23_v13 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_textbox).clear().type('12')
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err_nv()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_city_err_textbox).clear().type('A+')
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    adl1_err_nv()
    city_err()
    pc_err_nv()
}
//all fields valid 
export const childs_accommodation_step_23_v14 = () => {
    page_heading()
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_addr_line2_textbox).type(secrets.child_line2)
    cy.get(elements.step23_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
}
//*******SPONSOR ADDRESS**************SPONSOR ADDRESS**************SPONSOR ADDRESS**************SPONSOR ADDRESS****************************SPONSOR ADDRESS**************
const s26_page_heading = () => { cy.get(elements.page_heading).contains('Enter the address where you will be living in the UK').should('be.visible') }
const sbox_title = () => { cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible') }
const s26_all_sbox_fields_err = () => {
    sbox_title()
    cy.xpath(elements.step26_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.xpath(elements.step26_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.xpath(elements.step26_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const s26_all_fields_err = () => {
    cy.get(elements.step26_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step26_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step26_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const s26_adl1_err = () => {
    sbox_title()
    cy.xpath(elements.step26_addr_sbox_err_msg).contains(bt_err.address_err_msg).should('be.visible')
    cy.get(elements.step26_addr_err_msg).contains(bt_err.address_err_msg).should('be.visible')
}
const s26_city_err = () => {
    sbox_title()
    cy.xpath(elements.step26_city_sbox_err_msg).contains(bt_err.city_err_msg).should('be.visible')
    cy.get(elements.step26_city_err_msg).contains(bt_err.city_err_msg).should('be.visible')
}
const s26_pc_err = () => {
    sbox_title()
    cy.xpath(elements.step26_pc_sbox_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
    cy.get(elements.step26_pc_err_msg).contains(bt_err.pc_err_msg).should('be.visible')
}
const s26_adl1_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step26_addr_sbox_err_msg).should('not.exist')
    cy.get(elements.step26_addr_err_msg).should('not.exist')
}
const s26_city_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step26_city_sbox_err_msg).should('not.exist')
    cy.get(elements.step26_city_err_msg).should('not.exist')
}
const s26_pc_err_nv = () => {
    sbox_title()
    cy.xpath(elements.step26_pc_sbox_err_msg).should('not.exist')
    cy.get(elements.step26_pc_err_msg).should('not.exist')
}
export const childs_accommodation_step_26_v1 = () => {
    cy.visit('/sponsor-a-child/steps/23')
    cy.get(elements.step23_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step23_addr_line2_textbox).type(secrets.child_line2)
    cy.get(elements.step23_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step23_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    cy.get(elements.step24_no_btn).click()
    click_continue()
    //delete above after the bug fix
    cy.visit('/sponsor-a-child/steps/26')
    click_continue()
    s26_page_heading()
    s26_all_sbox_fields_err()
    s26_all_fields_err()
}
//one field empty [AL1: empty, TC: valid, PC: valid]
export const childs_accommodation_step_26_v2 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear()
    cy.get(elements.step26_addr_line2_err_textbox).clear()
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err_nv()
}
//one field empty [AL1: valid, TC: empty, PC: valid]
export const childs_accommodation_step_26_v3 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_textbox).clear()
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err_nv()
}
//one field empty [AL1: valid, TC: valid, PC: empty]
export const childs_accommodation_step_26_v4 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_textbox).clear()
    click_continue()
    s26_adl1_err_nv()
    s26_city_err_nv()
    s26_pc_err()
}
//two fields empty [AL1: valid, TC: empty, PC: empty]
export const childs_accommodation_step_26_v5 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_textbox).clear()
    cy.get(elements.step26_pc_err_textbox).clear()
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err()
}
//two fields empty [AL1: empty, TC: valid, PC: empty]
export const childs_accommodation_step_26_v6 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear()
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear()
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err()
}
//two fields empty [AL1: empty, TC: empty, PC: valid]
export const childs_accommodation_step_26_v7 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear()
    cy.get(elements.step26_city_textbox).clear()
    cy.get(elements.step26_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err()
    s26_pc_err_nv()
}
//one field valid [AL1: valid, TC: invalid, PC: invalid] {Requirement: Three characters minimum for addr.l1 & city}
export const childs_accommodation_step_26_v8 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_err_textbox).clear().type('A')
    cy.get(elements.step26_pc_textbox).clear().type('*** ***')
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_err_textbox).clear().type('XY')
    cy.get(elements.step26_pc_err_textbox).clear().type('123 456')
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err()
}
//one field valid [AL1: invalid, TC: valid, PC: invalid]
export const childs_accommodation_step_26_v9 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear().type('X')
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear().type('ABC XYZ')
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type('AB')
    cy.get(elements.step26_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear().type('RM8 1')
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err()
}
//one field valid [AL1: invalid, TC: invalid, PC: valid]
export const childs_accommodation_step_26_v10 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type('£')
    cy.get(elements.step26_city_textbox).clear().type('[]')
    cy.get(elements.step26_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err()
    s26_pc_err_nv()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type('##')
    cy.get(elements.step26_city_err_textbox).clear().type('$$')
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err()
    s26_pc_err_nv()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type('1')
    cy.get(elements.step26_city_err_textbox).clear().type('2')
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err()
    s26_pc_err_nv()
}
//two fields valid [AL1: valid, TC: valid, PC: invalid]
export const childs_accommodation_step_26_v11 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_textbox).clear().type('NW10 1A')
    click_continue()
    s26_adl1_err_nv()
    s26_city_err_nv()
    s26_pc_err()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear().type('GW10 1A+')
    click_continue()
    s26_adl1_err_nv()
    s26_city_err_nv()
    s26_pc_err()
}
//two fields valid [AL1: invalid, TC: valid, PC: valid]
export const childs_accommodation_step_26_v12 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear().type('22')
    cy.get(elements.step26_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_err_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err_nv()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type('0+')
    cy.get(elements.step26_city_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err()
    s26_city_err_nv()
    s26_pc_err_nv()
}
//two fields valid [AL1: valid, TC: invalid, PC: valid]
export const childs_accommodation_step_26_v13 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_err_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_textbox).clear().type('12')
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err_nv()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_city_err_textbox).clear().type('A+')
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    s26_adl1_err_nv()
    s26_city_err()
    s26_pc_err_nv()
}
//all fields valid 
export const childs_accommodation_step_26_v14 = () => {
    s26_page_heading()
    cy.get(elements.step26_addr_line1_textbox).clear().type(secrets.child_line1)
    cy.get(elements.step26_addr_line2_textbox).type(secrets.child_line2)
    cy.get(elements.step26_city_err_textbox).clear().type(secrets.child_town_or_city)
    cy.get(elements.step26_pc_textbox).clear().type(secrets.child_postcode)
    click_continue()
    cy.get(elements.page_heading).contains('Enter the name of a person over 16 who will live with the child').should('be.visible')
}
//*******PERSON OVER 16**************PERSON OVER 16**************PERSON OVER 16**************PERSON OVER 16****************************PERSON OVER 16**************
const s27_page_heading = () => {
    cy.get(elements.page_heading).contains('Enter the name of a person over 16 who will live with the child').should('be.visible')
}
const fn_err_no = () => {
    cy.xpath(elements.step27_fn_sbox_err_msg).should('not.exist')
    cy.get(elements.step27_fn_err_msg).should('not.exist')
}
const gn_err_no = () => {
    cy.xpath(elements.step27_gn_sbox_err_msg).should('not.exist')
    cy.get(elements.step27_gn_err_msg).should('not.exist')
}
const fn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step27_fn_sbox_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
    cy.get(elements.step27_fn_err_msg).contains(bt_err.fn_err_msg).should('be.visible')
}
const gn_err_yes = () => {
    cy.get(elements.err_summary_title).contains(bt_err.sbox_title_msg).should('be.visible')
    cy.xpath(elements.step27_gn_sbox_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
    cy.get(elements.step27_gn_err_msg).contains(bt_err.gn_err_msg).should('be.visible')
}
//empty fields: [GN: empty, FN: empty]
export const your_details_name_step_27_v1 = () => {
    cy.visit('/sponsor-a-child/steps/27')
    s27_page_heading()
    cy.get(elements.step27_gn_textbox).clear()
    cy.get(elements.step27_fn_textbox).clear()
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field empty: [GN: valid, FN: empty]
export const your_details_name_step_27_v2 = () => {
    s27_page_heading()
    cy.get(elements.step27_gn_err_textbox).clear().type(secrets.given_names)
    cy.get(elements.step27_fn_err_textbox).clear()
    click_continue()
    fn_err_yes()
    gn_err_no()
}
//one field empty: [GN: Empty, FN: Valid]
export const your_details_name_step_27_v3 = () => {
    s27_page_heading()
    cy.get(elements.step27_gn_textbox).clear()
    cy.get(elements.step27_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    gn_err_yes()
    fn_err_no()
}
//both fields invalid: [GN: invalid, FN: invalid]
export const your_details_name_step_27_v4 = () => {
    s27_page_heading()
    cy.get(elements.step27_gn_err_textbox).clear().type('1')
    cy.get(elements.step27_fn_textbox).clear().type('£')
    click_continue()
    fn_err_yes()
    gn_err_yes()
}
//one field valid: [GN: invalid, FN: valid]
export const your_details_name_step_27_v5 = () => {
    s27_page_heading()
    cy.get(elements.step27_gn_err_textbox).clear().type('+++++-')
    cy.get(elements.step27_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step27_gn_err_textbox).clear().type('123456')
    cy.get(elements.step27_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step27_gn_err_textbox).clear().type('bet4a')
    cy.get(elements.step27_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step27_gn_err_textbox).clear().type('.chali')
    cy.get(elements.step27_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
    cy.get(elements.step27_gn_err_textbox).clear().type('££$$**()')
    cy.get(elements.step27_fn_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_yes()
}
//one field valid: [GN: valid, FN: invalid]
export const your_details_name_step_27_v6 = () => {
    s27_page_heading()
    cy.get(elements.step27_gn_err_textbox).clear().type(secrets.family_name)
    cy.get(elements.step27_fn_textbox).clear().type('+++++-')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step27_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step27_fn_err_textbox).clear().type('rome0')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step27_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step27_fn_err_textbox).clear().type('.hfu')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step27_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step27_fn_err_textbox).clear().type('Homes + Ukraine')
    click_continue()
    fn_err_yes()
    gn_err_no()
    cy.get(elements.step27_gn_textbox).clear().type(secrets.family_name)
    cy.get(elements.step27_fn_err_textbox).clear().type('$$$$££££')
    click_continue()
    fn_err_yes()
    gn_err_no()
}
//both fields valid: [GN: valid, FN: valid]
export const your_details_name_step_27_v7 = () => {
    cy.get(elements.step27_gn_textbox).clear().type(secrets.given_names)
    cy.get(elements.step27_fn_err_textbox).clear().type(secrets.family_name)
    click_continue()
    fn_err_no()
    gn_err_no()
    cy.get(elements.page_heading).contains('You have added 1 person over 16 who will live with the child').should('be.visible')
}

