import { test, expect, Page } from '@playwright/test'
import { randomEmail, randomString } from './helpers'

const login = async (page: Page) => {
  const email = randomEmail()
  await page.fill('[name="traits.email"]', email)
  await page.fill('[name="password"]', randomString())
  await page.click('[value="password"]')
  return email
}

test.describe('django-ory-cloud', () => {
  const url = 'http://localhost:4000/'
  const name = 'django'
  {
    test.describe('django', async () => {
      test('login and sign up', async ({ page }) => {
        await page.goto(url, { waitUntil: 'networkidle' })

        await page.locator('text=Sign in').click()
        await expect(page).toHaveURL(/.*\/ui\/login.*/)

        await page.click('[data-testid="cta-link"]')
        await expect(page).toHaveURL(/.*\/ui\/registration.*/)

        const email = await login(page)
        await expect(page).toHaveURL(/.*\/ui\/welcome.*/)
        await expect(page.locator('body')).toContainText(email)
      })
    })
  }
})

// test.describe("Single Page App + API", () => {
//   test("able to use login and sign up", async ({ page }) => {
//     await page.goto("http://localhost:4006/")
//     await page.locator('[data-testid="sign-up"]').click()
//     await expect(page).toHaveURL(/.*\/ui\/registration.*/)

//     const email = await login(page)
//     await expect(page).toHaveURL(/.*\/localhost:4006.*/)

//     await expect(page.locator('[data-testid="ory-response"]')).toContainText(
//       "password",
//     )
//     await expect(page.locator('[data-testid="api-response"]')).toContainText(
//       email,
//     )

//     await page.locator('[data-testid="settings"]').click()
//     await expect(page).toHaveURL(/.*\/ui\/settings.*/)

//     await page.goto("http://localhost:4006/")
//     await page.waitForLoadState("networkidle")
//     await page.locator('[data-testid="logout"]').click()
//     await expect(page).toHaveURL(/.*\/localhost:4006.*/)

//     // Click a:has-text("Login")
//     await page.locator('[data-testid="sign-in"]').click()
//     await expect(page).toHaveURL(/.*\/ui\/login.*/)
//   })
// })

// test.describe("React Single Page App", () => {
//   test("able to use Sign in and Login", async ({ page }) => {
//     await page.goto("http://localhost:4008/")
//     await page.waitForLoadState("networkidle")
//     await page.click('[data-testid="cta-link"]')
//     await expect(page).toHaveURL(/.*\/ui\/registration.*/)

//     const email = await login(page)
//     await expect(page).toHaveURL("http://localhost:4008")
//     await expect(page.locator("body")).toContainText(email)

//     await page.locator("text=Logout").click()
//   })
// })
