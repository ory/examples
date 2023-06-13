import { parseBody } from 'next/dist/server/api-utils/node';
import React from 'react';

import { hydraAdmin } from '../../lib/hydra';
import { redirect } from '../../lib/ssr-helpers';

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
};

export async function getServerSideProps({ req, res, query }) {
  // only accept GET and POST requests
  if (!['GET', 'POST'].includes(req.method)) return {notFound: true};

  let props = {
    action: req.url,
    csrfToken: res.getHeader('x-csrf-token'),
    message: '',
  };

  // get oauth logout challenge from url
  const { logout_challenge } = query;

  // logout_challenge is required
  if (!logout_challenge) {
    // render form
    res.statusCode = 400;
    props.message = 'Logout challenge is missing';
    return { props };
  }

  // get logout request from hydra
  try {
    await hydraAdmin.getLogoutRequest(logout_challenge);
  } catch (e) {
    if (e.response?.status === 404) {
      // render form
      res.statusCode = 400;
      props.message = 'Logout challenge not found';
      return { props };
    }
    throw e;
  }

  // process submission
  if (req.method === 'POST') {
    const formData = await parseBody(req, '1mb');

    // check if user canceled request
    if (formData.button === 'cancel') {
      // reject request and redirect somewhere
      await hydraAdmin.rejectLogoutRequest(logout_challenge);
      return redirect(303, 'https://www.google.com/');
    }

    // accept the logout request
    const acceptLogoutRequestResponse = await hydraAdmin.acceptLogoutRequest(logout_challenge);
    return redirect(303, acceptLogoutRequestResponse.data.redirect_to);
  }
  
  // render form
  return { props };
}

export default function SignOut({ action, csrfToken, message }) {
  return (
    <>
      <h1>Sign Out:</h1>
      <form
        action={action}
        method="post"
      >
        {message && <div style={{color: 'red'}}>{message}</div>}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <p>Do you want to log out?</p>
        <div>
          <button name="button" value="submit" type="submit">Logout</button>
          <button name="button" value="cancel" type="submit">Cancel</button>
        </div>
      </form>
    </>
  );
}
