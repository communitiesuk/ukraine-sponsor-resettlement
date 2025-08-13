const { defineConfig } = require('cypress');
const dotenv = require('dotenv');

dotenv.config()

module.exports = defineConfig({
  chromeWebSecurity: false,
  video: false,
  videoUploadOnPasses: true,
  videoCompression: false,
  viewportWidth: 1000,
  viewportHeight: 1500,
  reporter: 'cypress-mochawesome-reporter',
  reporterOptions: {
    charts: true,
    reportPageTitle: 'custom-title',
    embeddedScreenshots: true,
    inlineAssets: true,
    saveAllAttempts: false,
  },
  e2e: {
    setupNodeEvents(on, config) {
      require('cypress-mochawesome-reporter/plugin')(on);
      require('cypress-high-resolution')(on, config)
    },
  baseUrl: process.env.BASE_URL || 'http://localhost:8080',
  userAgent: 'CYPRESS-E2E',
  excludeSpecPattern: process.env.all ? ['cypress/e2e/integration/EOI/run_all_eoi_specs.cy.js','cypress/e2e/integration/UAM/run_all_uam_specs.cy.js'] : [],
  },
  env: {
    waitTime: 150, // if you change this on your machine, do not commit!!!
  }
});