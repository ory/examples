import type { ConsentRequest } from '@ory/hydra-client';
import type { AxiosError } from 'axios';
import type { GetServerSideProps } from 'next';
import React from 'react';

import { hydraAdmin } from '@/lib/hydra';
import { redirect, parseBody } from '@/lib/ssr-helpers';

type Props = {
  action: string,
  consentRequest: ConsentRequest,
  csrfToken: string,
  message: string,
};

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
};

const sessionData = (consentRequest: ConsentRequest) => {
  return {
    access_token: {
      key1: 'val1',
    },
    id_token: {
      key2: 'val2',
      email: consentRequest.subject,
    },
  };
};

export const getServerSideProps: GetServerSideProps = async ({
  req,
  res,
  query,
}) => {
  // only accept GET and POST requests
  if (!['GET', 'POST'].includes(req.method || '')) return {notFound: true};

  let props = {
    action: req.url,
    consentRequest: {},
    csrfToken: res.getHeader('x-csrf-token') || '',
    message: '',
  };

  // get oauth consent challenge from url
  let { consent_challenge } = query;

  // de-listify
  consent_challenge = Array.isArray(consent_challenge) ? consent_challenge[0] : consent_challenge;

  if (!consent_challenge) {
    // render form
    res.statusCode = 400;
    props.message = 'Consent challenge is missing';
    return { props };
  }

  // get consent request from hydra
  let consentRequestResponse;

  try {
    consentRequestResponse = await hydraAdmin.getConsentRequest(consent_challenge);
  } catch (e) {
    if ((e as AxiosError).response?.status === 404) {
      // render form
      res.statusCode = 400;
      props.message = 'Consent challenge not found';
      return { props };
    }
    throw e;
  }

  const consentRequest = consentRequestResponse.data;

  // if user has granted application requested scope, hydra will tell us not to show ui
  if (consentRequest.skip) {
    const acceptConsentRequestResponse = await hydraAdmin.acceptConsentRequest(consent_challenge, {
      grant_scope: consentRequest.requested_scope,
      grant_access_token_audience: consentRequest.requested_access_token_audience,
      session: sessionData(consentRequest),
    });

    // mission accomplished! redirect user back to hydra                                                                       
    return redirect(303, acceptConsentRequestResponse.data.redirect_to);
  }

  // process submission
  if (req.method === 'POST') {
    const formData = await parseBody(req, '1mb');

    // check if user canceled request
    if (formData.button === 'reject') {
      const rejectConsentRequestResponse = await hydraAdmin.rejectConsentRequest(consent_challenge, {
        error: 'access_denied',
        error_description: 'The resource owner denied the request'
      });

      // redirect user back to hydra
      return redirect(303, rejectConsentRequestResponse.data.redirect_to);
    }

    // listify grant_scope
    let grant_scope = formData.grant_scope || [];
    grant_scope = Array.isArray(grant_scope) ? grant_scope : [grant_scope];

    // tell hydra user has accepted consent request                                                                            
    const acceptConsentRequestResponse = await hydraAdmin.acceptConsentRequest(consent_challenge, {
      grant_scope: grant_scope,
      grant_access_token_audience: consentRequest.requested_access_token_audience,
      session: sessionData(consentRequest),
      remember: Boolean(formData.remember),
      remember_for: 3600,
    });

    // mission accomplished! redirect user back to hydra
    return redirect(303, acceptConsentRequestResponse.data.redirect_to);
  }

  // render form
  props.consentRequest = consentRequest;
  return { props };
}

const Consent: React.FunctionComponent<Props> = ({
  action,
  consentRequest,
  csrfToken,
  message,
}) => {
  return (
    <>
      <h1>Give consent:</h1>
      <form
        action={action}
        method="post"
      >
        {message && <div style={{ color: 'red' }}>{message}</div>}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <p>
          Hello {consentRequest.subject}!
        </p>
        <p>
          Client <strong>{consentRequest.client?.client_name || consentRequest.client?.client_id}</strong> wants to access you\
          r resources on your behalf and to:
        </p>
        {consentRequest.requested_scope?.map((scope: string, k: number) => (
          <div key={k}>
            <input id={`grant_scope_${scope}`} type="checkbox" name="grant_scope" defaultValue={scope} />
            <label htmlFor={`grant_scope_${scope}`}>{scope}</label>
          </div>
        ))}
        <p>
          Do you want to be asked next time when this application wants to access your data? The application will
          not be able to ask for more permissions without your consent.
        </p>
        <ul>
          {consentRequest.client?.policy_uri && <li><a href={consentRequest.client.policy_uri}>Policy</a></li>}
          {consentRequest.client?.tos_uri && <li><a href={consentRequest.client.tos_uri}>Terms of Service</a></li>}
        </ul>
        <div>
          <input id="remember" type="checkbox" name="remember" value="1" />
          <label htmlFor="remember">Do not ask me again</label>
        </div>
        <div>
          <button name="button" value="accept" type="submit">Accept</button>
          <button name="button" value="reject" type="submit">Reject</button>
        </div>
      </form>
    </>
  )
}

export default Consent;
