// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

describe("CSRF protection tests", () => {
  const authPaths = ["/sign-in", "/sign-up", "/sign-out", "/consent"]

  context("should reject POST request without csrf token", () => {
    authPaths.forEach((path) => {
      it(path, async () => {
        const response = await cy.request({
          method: "POST",
          url: "/auth" + path,
          failOnStatusCode: false,
        })
        expect(response.status).to.equal(403)
      })
    })
  })

  context("should reject POST request with invalid csrf token", () => {
    authPaths.forEach((path) => {
      it(path, async () => {
        const response = await cy.request({
          method: "POST",
          url: "/auth" + path,
          form: true,
          body: {
            csrf_token: "invalid-token",
          },
          failOnStatusCode: false,
        })
        expect(response.status).to.equal(403)
      })
    })
  })
})
