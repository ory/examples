const { createHash } = require("crypto");

class LoginPage {
  async fillIdentifier(text) {
    return page.fill("data-testid=password_identifier", text);
  }

  async fillPassword(text) {
    return page.fill("data-testid=password", text);
  }

  async submit() {
    return page.click("data-testid=submit");
  }
}

class RegisterPage {
  async go() {
    await page.goto("http://127.0.0.1:3000/register");
  }

  async new(email, password) {
    await page.fill("data-testid=traits.email", email);
    await page.fill("data-testid=password", password);
    await page.fill("data-testid=traits.name.first", "test");
    await page.fill("data-testid=traits.name.last", "user");
    await page.click("data-testid=submit");
  }
}

async function generateUser() {
    const register = new RegisterPage()
    const dashboard = new DashboardPage();
    const p = new TestUserProvider();
    const email = p.seed()
    const password = "zipzopzoey";

    await register.go();
    await register.new(email, password);
    let _ = await dashboard.greeting();

    expect(page.url()).toBe("http://127.0.0.1:3000/")

    // Stores browser context for authenticated state later on.
    const storage = await context.storageState();
    process.env.STORAGE = JSON.stringify(storage);
    await context.clearCookies();
    return new TestUser(email, password);
}

class DashboardPage {
  async greeting() {
    return page.textContent("data-testid=greeting");
  }
}

class TestUser {
  constructor(email, password) {
    this.email = email;
    this.password = password;
  }

}

class TestUserProvider {
  constructor() {
    this.hash = createHash("md5");
  }

  seed() {
    let now = new Date();
    this.hash.update(now.toISOString());
    const hash = this.hash.copy().digest("base64");
    return `testuser_${hash}@test.com`;
  }
}

describe("Login", () => {
  let user;

  beforeAll(async () => {
    user = await generateUser();
  });

  afterEach(async () => {
    await page.context().clearCookies();
  });

  test("user should be able to login", async () => {
    await page.goto("http://127.0.0.1:3000/login");
    let login = new LoginPage();
    let dashboard = new DashboardPage();

    await login.fillIdentifier(user.email);
    await login.fillPassword(user.password);
    await login.submit();
    let _ = await dashboard.greeting();

    expect(page.url()).toBe("http://127.0.0.1:3000/")
  });

  test("user should be redirected after successful login", async () => {
    const redirectURL = "https://www.google.com";
    await page.goto(`http://127.0.0.1:3000/login?return_to=${redirectURL}`);
    let login = new LoginPage();
    let dashboard = new DashboardPage();

    await login.fillIdentifier(user.email);
    await login.fillPassword(user.password);
    await login.submit();
    await page.waitForNavigation();
    expect(page.url()).toContain(redirectURL);
  });

  test("user should be redirected after successful login", async () => {
    const redirectURL = "https%3A%2F%2Fwww.google.com%2F"; // url safe encoding
    const expectedURL = "https://www.google.com";

    await page.goto(`http://127.0.0.1:3000/login?return_to=${redirectURL}`);
    let login = new LoginPage();
    let dashboard = new DashboardPage();

    await login.fillIdentifier(user.email);
    await login.fillPassword(user.password);
    await login.submit();
    await page.waitForNavigation();
    expect(page.url()).toContain(expectedURL);
  });
});

