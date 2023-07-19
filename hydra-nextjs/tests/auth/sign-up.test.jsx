import "@testing-library/jest-dom"
import { render, screen } from "@testing-library/react"

import { hydraAdmin } from "../../lib/hydra"
import SignUp, { getServerSideProps } from "../../pages/auth/sign-up"

import { mockRequest, mockResponse } from "../helpers"

jest.mock("../../lib/hydra")

describe("SignInPage", () => {
  it("renders all form input elements", () => {
    const result = render(<SignUp action="" formData={{}} formErrors={{}} />)

    const inputs = result.container.querySelectorAll("input")
    expect(inputs.length).toEqual(5)
    expect(inputs[0].name).toEqual("csrf_token")
    expect(inputs[1].name).toEqual("email")
    expect(inputs[2].name).toEqual("password")
    expect(inputs[3].name).toEqual("password_confirm")
    expect(inputs[4].name).toEqual("remember")
  })

  it("renders generic error message properly", () => {
    render(
      <SignUp
        action=""
        message="Generic error message"
        formData={{}}
        formErrors={{}}
      />,
    )
    expect(screen.getByText("Generic error message")).toBeTruthy()
  })

  it("renders email error message properly", () => {
    render(
      <SignUp
        action=""
        message=""
        formData={{}}
        formErrors={{ email: "Email missing" }}
      />,
    )
    expect(screen.getByText("Email missing")).toBeTruthy()
  })
})

describe("getServerSideProps", () => {
  afterEach(() => jest.resetAllMocks())

  it("Rejects non-GET/POST requests", async () => {
    const req = mockRequest({ method: "OTHER" })
    const result = await getServerSideProps({ req })
    expect(result.notFound).toEqual(true)
  })

  describe("GET and POST", () => {
    const methods = ["GET", "POST"]

    it.each(methods)("%s: Requires `login_challenge`", async (method) => {
      const req = mockRequest({ method })
      const res = mockResponse()
      const query = {}
      const result = await getServerSideProps({ req, res, query })
      expect(result.props.message).toEqual("Login challenge is missing")
      expect(res.statusCode).toEqual(400)
    })

    it.each(methods)("%s: Rejects empty `login_challenge`", async (method) => {
      const req = mockRequest({ method })
      const res = mockResponse()
      const query = { login_challenge: "" }
      const result = await getServerSideProps({ req, res, query })
      expect(result.props.message).toEqual("Login challenge is missing")
      expect(res.statusCode).toEqual(400)
    })

    it.each(methods)("%s: Requires valid `login_challenge`", async (method) => {
      hydraAdmin.getLoginRequest = jest.fn(() => {
        let e = new Error()
        e.response = { status: 404 }
        throw e
      })

      const req = mockRequest({ method })
      const res = mockResponse()
      const query = { login_challenge: "invalid" }
      const result = await getServerSideProps({ req, res, query })
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith("invalid")
      expect(result.props.message).toEqual("Login challenge not found")
      expect(res.statusCode).toEqual(400)
    })
  })

  describe("GET", () => {
    it("Renders form when `login_challenge` is valid and skip is false", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      const req = mockRequest({
        method: "GET",
        url: "/auth/sign-up?login_challenge=valid",
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check getLoginRequest()
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith("valid")

      // check acceptLoginRequest()
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(0)

      // check result
      expect(result).toMatchObject({
        props: {
          action: "/auth/sign-up?login_challenge=valid",
          message: "",
          formData: {},
          formErrors: {},
        },
      })
      expect(res.statusCode).toEqual(200)
    })
  })

  describe("POST", () => {
    it("Rejects hydra loginRequest when user clicks `cancel`", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      hydraAdmin.rejectLoginRequest.mockReturnValue({
        data: { redirect_to: "/redirect-url" },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body: "button=cancel",
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check getLoginRequest()
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith("valid")

      // check acceptLoginRequest()
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(0)

      // check rejectLoginRequest()
      expect(hydraAdmin.rejectLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.rejectLoginRequest).toHaveBeenCalledWith("valid", {
        error: "access_denied",
        error_description: "The resource owner denied the request",
      })

      // check result
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: "/redirect-url",
        },
      })
    })

    it("Rejects missing email", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body: "",
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            email: "Please enter your email address",
          },
        },
      })
      expect(res.statusCode).toEqual(400)
    })

    it("Rejects missing password", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body: "",
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            password: "Please choose a password",
          },
        },
      })
      expect(res.statusCode).toEqual(400)
    })

    it("Rejects incorrect password confirmation", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body: "password=x&password_confirm=y",
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            password_confirm: "Passwords must match",
          },
        },
      })
      expect(res.statusCode).toEqual(400)
    })

    it("Rejects emails already in use", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body:
          "password=x&password_confirm=x&email=" +
          encodeURIComponent("foo@bar.com"),
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check result
      expect(result).toMatchObject({
        props: {
          message: "Email is already in use",
        },
      })
      expect(res.statusCode).toEqual(400)
    })

    it("Accepts valid submission", async () => {
      hydraAdmin.getLoginRequest.mockReturnValue({
        data: { skip: false },
      })

      hydraAdmin.acceptLoginRequest.mockReturnValue({
        data: { redirect_to: "/redirect-url" },
      })

      const req = mockRequest({
        method: "POST",
        headers: {
          "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        },
        body:
          "remember=1&password=x&password_confirm=x&email=" +
          encodeURIComponent("email@example.com"),
      })
      const res = mockResponse()
      const query = { login_challenge: "valid" }
      const result = await getServerSideProps({ req, res, query })

      // check getLoginRequest()
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith("valid")

      // check acceptLoginRequest()
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(1)
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledWith("valid", {
        subject: "email@example.com",
        remember: true,
        remember_for: 3600,
        acr: "0",
      })

      // check result
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: "/redirect-url",
        },
      })
    })
  })
})
