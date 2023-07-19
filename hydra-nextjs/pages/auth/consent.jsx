import { parseBody } from "next/dist/server/api-utils/node"
import React from "react"

import { hydraAdmin } from "../../lib/hydra"
import { redirect } from "../../lib/ssr-helpers"

export const config = {
  unstable_runtimeJS: false, // disable client-side javascript (in production)
}

const sessionData = (consentRequest) => {
  return {
    access_token: {
      key1: "val1",
    },
    id_token: {
      key2: "val2",
      email: consentRequest.subject,
    },
  }
}

export async function getServerSideProps({ req, res, query }) {
  // only accept GET and POST requests
  if (!["GET", "POST"].includes(req.method)) return { notFound: true }

  let props = {
    action: req.url,
    consentRequest: {},
    csrfToken: res.getHeader("x-csrf-token"),
    message: "",
  }

  // get oauth consent challenge from url
  const { consent_challenge } = query

  if (!consent_challenge) {
    // render form
    res.statusCode = 400
    props.message = "Consent challenge is missing"
    return { props }
  }

  // get consent request from hydra
  let consentRequestResponse

  try {
    consentRequestResponse = await hydraAdmin.getConsentRequest(
      consent_challenge,
    )
  } catch (e) {
    if (e.response?.status === 404) {
      // render form
      res.statusCode = 400
      props.message = "Consent challenge not found"
      return { props }
    }
    throw e
  }

  const consentRequest = consentRequestResponse.data

  // if user has granted application requested scope, hydra will tell us not to show ui
  if (consentRequest.skip) {
    const acceptConsentRequestResponse = await hydraAdmin.acceptConsentRequest(
      consent_challenge,
      {
        grant_scope: consentRequest.requested_scope,
        grant_access_token_audience:
          consentRequest.requested_access_token_audience,
        session: sessionData(consentRequest),
      },
    )

    // mission accomplished! redirect user back to hydra
    return redirect(303, acceptConsentRequestResponse.data.redirect_to)
  }

  // process submission
  if (req.method === "POST") {
    const formData = await parseBody(req, "1mb")

    // check if user canceled request
    if (formData.button === "reject") {
      const rejectConsentRequestResponse =
        await hydraAdmin.rejectConsentRequest(consent_challenge, {
          error: "access_denied",
          error_description: "The resource owner denied the request",
        })

      // redirect user back to hydra
      return redirect(303, rejectConsentRequestResponse.data.redirect_to)
    }

    // listify grant_scope
    let grant_scope = formData.grant_scope || []
    grant_scope = Array.isArray(grant_scope) ? grant_scope : [grant_scope]

    // tell hydra user has accepted consent request
    const acceptConsentRequestResponse = await hydraAdmin.acceptConsentRequest(
      consent_challenge,
      {
        grant_scope: grant_scope,
        grant_access_token_audience:
          consentRequest.requested_access_token_audience,
        session: sessionData(consentRequest),
        remember: Boolean(formData.remember),
        remember_for: 3600,
      },
    )

    // mission accomplished! redirect user back to hydra
    return redirect(303, acceptConsentRequestResponse.data.redirect_to)
  }

  // render form
  props.consentRequest = consentRequest
  return { props }
}

export default function Consent({
  action,
  consentRequest,
  csrfToken,
  message,
}) {
  return (
    <>
      <h1>Give consent:</h1>
      <form action={action} method="post">
        {message && <div style={{ color: "red" }}>{message}</div>}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <p>Hello {consentRequest.subject}!</p>
        <p>
          Client{" "}
          <strong>
            {consentRequest.client?.client_name ||
              consentRequest.client?.client_id}
          </strong>{" "}
          wants to access your resources on your behalf and to:
        </p>
        {consentRequest.requested_scope?.map((scope, k) => (
          <div key={k}>
            <input
              id={`grant_scope_${scope}`}
              type="checkbox"
              name="grant_scope"
              defaultValue={scope}
            />
            <label htmlFor={`grant_scope_${scope}`}>{scope}</label>
          </div>
        ))}
        <p>
          Do you want to be asked next time when this application wants to
          access your data? The application will not be able to ask for more
          permissions without your consent.
        </p>
        <ul>
          {consentRequest.client?.policy_uri && (
            <li>
              <a href={consentRequest.client.policy_uri}>Policy</a>
            </li>
          )}
          {consentRequest.client?.tos_uri && (
            <li>
              <a href={consentRequest.client.tos_uri}>Terms of Service</a>
            </li>
          )}
        </ul>
        <div>
          <input id="remember" type="checkbox" name="remember" value="1" />
          <label htmlFor="remember">Do not ask me again</label>
        </div>
        <div>
          <button name="button" value="accept" type="submit">
            Accept
          </button>
          <button name="button" value="reject" type="submit">
            Reject
          </button>
        </div>
      </form>
    </>
  )
}
