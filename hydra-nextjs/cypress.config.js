// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

const { defineConfig } = require("cypress")

module.exports = defineConfig({
  screenshotOnRunFailure: false,
  video: false,
  e2e: {
    baseUrl: "http://localhost:3000",
    supportFile: false,
  },
})
