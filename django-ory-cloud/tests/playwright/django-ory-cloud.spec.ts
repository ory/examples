import { test, expect, Page } from "@playwright/test"
import { randomEmail, randomString } from "./helpers"

const login = async (page: Page) => {
  const email = randomEmail()
  await page.fill('[name="traits.email"]', email)
  await page.fill('[name="password"]', randomString())
  await page.click('[value="password"]')
  return email
}

test.describe("django-ory-cloud", () => {
  const url = "http://localhost:4000/"
  const name = "django"
  test("login and sign up", async ({ page }) => {
    await page.goto(url, { waitUntil: "networkidle" })
    await page.locator("text=Sign in").click()
    await expect(page).toHaveURL(/.*\/ui\/login.*/)
    await page.click('[data-testid="cta-link"]')
    await expect(page).toHaveURL(/.*\/ui\/registration.*/)
    const email = await login(page)
    await expect(page).toHaveURL(/.*\/ui\/welcome.*/)
    await expect(page.locator("body")).toContainText(email)
  })
})
