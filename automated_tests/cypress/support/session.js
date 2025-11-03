import { v4 as uuidv4 } from "uuid"

const SESSION_COOKIE_NAME = "_ukraine_sponsor_resettlement_session"
const EOI_ENTRY_POINT = "/expression-of-interest/self-assessment/property-suitable"

const clearSession = () => cy.clearCookie(SESSION_COOKIE_NAME)

const newSession = () => {
  const sessionId = uuidv4()
  cy.session(sessionId, () => {
    clearSession()
    cy.visit(EOI_ENTRY_POINT)
  })
}

module.exports = {clearSession, newSession}
