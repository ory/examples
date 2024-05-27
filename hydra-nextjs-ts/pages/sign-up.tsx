import type { AxiosError } from 'axios';
import type { GetServerSideProps } from 'next';
import Nope from 'nope-validator';
import React from 'react';

import { hydraAdmin } from '../lib/hydra';
import { redirect, parseBody } from '../lib/ssr-helpers';

type Props = {
  action: string,
  csrfToken: string,
  message: string,
  formData: {[key: string]: any},
  formErrors: {[key: string]: any},
}

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
}

const SignUpForm = Nope.object().shape({
  email: Nope.string().required('Please enter your email address'),
  password: Nope.string().required('Please choose a password'),
  password_confirm: Nope.string().oneOf([Nope.ref('password')], 'Passwords must match'),
  remember: Nope.boolean(),
});

export const getServerSideProps: GetServerSideProps = async ({
  req,
  res,
  query,
}) => {
  // only accept GET and POST requests
  if (!['GET', 'POST'].includes(req.method || '')) return {notFound: true}

  let props = {
    action: req.url,
    csrfToken: res.getHeader('x-csrf-token'),
    message: '',
    formData: {},
    formErrors: {},
  }

  // get oauth login challenge from url
  let { login_challenge } = query;

  // de-listify
  login_challenge = Array.isArray(login_challenge) ? login_challenge[0] : login_challenge;

  // login_challenge is required
  if (login_challenge === undefined || login_challenge.trim() === '') {
    // render form
    res.statusCode = 400;
    props.message = 'Login challenge is missing';
    return { props };
  }

  // get login request from hydra
  let loginRequestResponse;

  try {
    loginRequestResponse = await hydraAdmin.getLoginRequest(login_challenge);
  } catch (e) {
    if ((e as AxiosError).response?.status === 404) {
      // render form
      res.statusCode = 400;
      props.message = 'Login challenge not found';
      return { props };
    }
    throw e;
  }

  // process submission
  if (req.method === 'POST') {
    res.statusCode = 400; // set default to 400
    
    const formData = await parseBody(req);

    // check if user canceled request
    if (formData.button === 'cancel') {
      const rejectLoginRequestResponse = await hydraAdmin.rejectLoginRequest(login_challenge, {
        error: 'access_denied',
        error_description: 'The resource owner denied the request',
      });

      // redirect user back to hydra
      return redirect(303, rejectLoginRequestResponse.data.redirect_to);
    }

    // validate form
    const formErrors = SignUpForm.validate(formData);

    if (!formErrors) {
      // TODO: create user account                                                       
      if (formData.email ==='foo@bar.com') {
        props.message = 'Email is already in use';
      } else {
        // tell hydra user account has been created                                      
        const acceptLoginRequestResponse = await hydraAdmin.acceptLoginRequest(login_challenge, {
          subject: formData.email,
          remember: Boolean(formData.remember),
          remember_for: 3600,
          acr: '0',
        });

        // mission accomplished! redirect user back to hydra                             
        return redirect(303, acceptLoginRequestResponse.data.redirect_to);
      }
    }

    // render form
    props.formData = formData;
    props.formErrors = formErrors || {};
    return { props };
  }

  // render 
  return { props };
}

const SignUp: React.FunctionComponent<Props> = ({
  action,
  csrfToken,
  message,
  formData,
  formErrors
}) => {
  return (
    <>
      <h1>Sign Up:</h1>
      <form
        action={action}
        method="post"
      >
        {message && <div style={{ color: 'red' }}>{message}</div>}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <div>
          <label htmlFor="email">Email: </label>
          <input id="email" name="email" type="text" defaultValue={formData.email} />
          {' '}(it&apos;s not foo@bar.com)
          {formErrors.email && <div style={{ color: 'red' }}>{formErrors.email}</div>}
        </div>
        <div>
          <label htmlFor="password">Password: </label>
          <input id="password" name="password" type="password" />
          {formErrors.password && <div style={{ color: 'red' }}>{formErrors.password}</div>}
        </div>
        <div>
          <label htmlFor="password_confirm">Confirm Password: </label>
          <input id="password_confirm" name="password_confirm" type="password" />
          {formErrors.password_confirm && <div style={{ color: 'red' }}>{formErrors.password_confirm}</div>}
        </div>
        <div>
          <input id="remember" type="checkbox" name="remember" value="1" defaultChecked={formData.remember} />
          <label htmlFor="remember">Rembember me</label>
          {formErrors.remember && <div style={{ color: 'red' }}>{formErrors.remember}</div>}
        </div>
        <div>
          <button name="button" value="submit" type="submit">Submit</button>
          <button name="button" value="cancel" type="submit">Cancel</button>
        </div>
      </form>
      <br />
      {'Or'}
      <br />
      <br />
      <div><a href={action.replace(/^\/sign-up/, '/sign-in')}>Sign into your account &raquo;</a></div>
    </>
  )
}

export default SignUp
