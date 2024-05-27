import type { AxiosError } from 'axios';
import type { GetServerSideProps } from 'next';
import React from 'react';

import { hydraAdmin } from '@/lib/hydra';
import { redirect, parseBody } from '@/lib/ssr-helpers';

type Props = {
  action: string,
  csrfToken: string,
  message: string,
};

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
};

export const getServerSideProps: GetServerSideProps = async ({
  req,
  res,
  query
}) => {
  // only accept GET and POST requests
  if (!['GET', 'POST'].includes(req.method || '')) return { notFound: true };

  let props = {
    action: req.url,
    csrfToken: res.getHeader('x-csrf-token') || '',
    message: '',
    formData: {},
    formErrors: {},
  };

  // get oauth login challenge from url
  let { logout_challenge } = query;

  // de-listify
  logout_challenge = Array.isArray(logout_challenge) ? logout_challenge[0] : logout_challenge;

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
    if ((e as AxiosError).response?.status === 404) {
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

  return { props };
};

const SignOut: React.FunctionComponent<Props> = ({
  action,
  csrfToken,
  message,
}) => {
  return (
    <>
      <h1>Sign Out:</h1>
      <form
        action={action}
        method="post"
      >
        {message && <div style={{ color: 'red' }}>{message}</div>}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <p>Do you want to log out?</p>
        <div>
          <button name="button" value="submit" type="submit">Logout</button>
          <button name="button" value="cancel" type="submit">Cancel</button>
        </div>
      </form>
    </>
  );
};

export default SignOut;
