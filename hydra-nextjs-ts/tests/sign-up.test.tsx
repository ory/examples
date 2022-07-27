import { render, screen } from '@testing-library/react';
import type { GetServerSidePropsContext } from 'next';
import httpMocks from 'node-mocks-http';
import type { RequestMethod } from 'node-mocks-http';
import type { ParsedUrlQuery } from 'querystring';

import { hydraAdmin } from '../lib/hydra';
import SignUp, { getServerSideProps } from '@/pages/sign-up';

jest.mock('@/lib/hydra');

describe('SignInPage', () => {
  it('renders all form input elements', () => {
    const result = render(
      <SignUp
        action=""
        csrfToken=""
        formData={{}}
        formErrors={{}}
        message=""
      />
    );

    const inputs = result.container.querySelectorAll('input');
    expect(inputs.length).toEqual(5);
    expect(inputs[0].name).toEqual('csrf_token');
    expect(inputs[1].name).toEqual('email');
    expect(inputs[2].name).toEqual('password');
    expect(inputs[3].name).toEqual('password_confirm');
    expect(inputs[4].name).toEqual('remember');
  });

  it('renders generic error message properly', () => {
    render(
      <SignUp
        action=""
        csrfToken=""
        message="Generic error message"
        formData={{}}
        formErrors={{}}
      />
    );
    expect(screen.getByText("Generic error message")).toBeTruthy();
  });

  it('renders email error message properly', () => {
    render(
      <SignUp
        action=""
        csrfToken=""
        message=""
        formData={{}}
        formErrors={{ email: "Email missing" }}
      />
    );
    expect(screen.getByText("Email missing")).toBeTruthy();
  });
});

describe('getServerSideProps', () => {
  afterEach(() => jest.resetAllMocks());

  it('Rejects non-GET/POST requests', async () => {
    const req = httpMocks.createRequest({method: 'PATCH'});
    const result = await getServerSideProps({ req } as GetServerSidePropsContext);
    expect(result).toHaveProperty('notFound');
    expect(result).toEqual({ notFound: true });
  });

  describe('GET and POST', () => {
    const methods: RequestMethod[] = ['GET', 'POST'];

    it.each(methods)('%s: Requires `login_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {};
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Login challenge is missing',
        },
      });
    });

    it.each(methods)('%s: Rejects empty `login_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = { login_challenge: '' } as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Login challenge is missing',
        },
      });
    });

    it.each(methods)('%s: Requires valid `login_challenge`', async (method) => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockImplementation(() => {
        let e = new Error();
        e = Object.assign(e, { response: { status: 404 }});
        throw e;
      });

      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {login_challenge: 'invalid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith('invalid');
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Login challenge not found',
        },
      });
    });
  });

  describe('GET', () => {
    it('Renders form when `login_challenge` is valid and skip is false', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'GET',
        url: '/auth/sign-up?login_challenge=valid'
      });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLoginRequest()                                                             
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith('valid');

      // check acceptLoginRequest()                                                          
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(0);

      // check result                                                                        
      expect(result).toMatchObject({
        props: {
          action: '/auth/sign-up?login_challenge=valid',
          message: '',
          formData: {},
          formErrors: {}
        }
      });
      expect(res.statusCode).toEqual(200);
    });
  });

  describe('POST', () => {
    it('Rejects hydra loginRequest when user clicks `cancel`', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      (hydraAdmin.rejectLoginRequest as jest.Mock).mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {button: 'cancel'},
      });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLoginRequest()
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith('valid');

      // check acceptLoginRequest()
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(0);

      // check rejectLoginRequest()
      expect(hydraAdmin.rejectLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.rejectLoginRequest).toHaveBeenCalledWith('valid', {
        error: 'access_denied',
        error_description: 'The resource owner denied the request'
      });

      // check result
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: '/redirect-url',
        },
      });
    });

    it('Rejects missing email', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      const { req, res } = httpMocks.createMocks({ method: 'POST' });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            email: 'Please enter your email address'
          }
        }
      });
      expect(res.statusCode).toEqual(400);
    });

    it('Rejects missing password', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      const { req, res } = httpMocks.createMocks({ method: 'POST' });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            password: 'Please choose a password'
          }
        }
      });
      expect(res.statusCode).toEqual(400);
    });

    it('Rejects incorrect password confirmation', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {
          password: 'x',
          password_confirm: 'y',
        },
      });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check result
      expect(result).toMatchObject({
        props: {
          formErrors: {
            password_confirm: 'Passwords must match'
          }
        }
      });
      expect(res.statusCode).toEqual(400);
    });

    it('Rejects emails already in use', async () => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {
          password: 'x',
          password_confirm: 'x',
          email: 'foo@bar.com'
        },
      });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check result                                                                    
      expect(result).toMatchObject({
        props: {
          message: 'Email is already in use'
        }
      });
      expect(res.statusCode).toEqual(400);
    });

    it('Accepts valid submission', async() => {
      (hydraAdmin.getLoginRequest as jest.Mock).mockReturnValue({
        data: {skip: false}
      });

      (hydraAdmin.acceptLoginRequest as jest.Mock).mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {
          password: 'x',
          password_confirm: 'x',
          email: 'email@example.com',
          remember: '1'
        },
      });
      const query = {login_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLoginRequest()
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLoginRequest).toHaveBeenCalledWith('valid');

      // check acceptLoginRequest()
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.acceptLoginRequest).toHaveBeenCalledWith('valid', {
        subject: 'email@example.com',
        remember: true,
        remember_for: 3600,
        acr: '0'
      });

      // check result                             
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: '/redirect-url'
        }
      });
    });
  });
});
