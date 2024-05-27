import { render, screen } from '@testing-library/react';
import type { GetServerSidePropsContext } from 'next';
import httpMocks from 'node-mocks-http';
import type { RequestMethod } from 'node-mocks-http';
import type { ParsedUrlQuery } from 'querystring';

import { hydraAdmin } from '@/lib/hydra';
import SignOut, { getServerSideProps } from '@/pages/sign-out';

jest.mock('@/lib/hydra');

describe('SignOutPage', () => {
  it('renders all form input elements', () => {
    const result = render(
      <SignOut
        action=""
        csrfToken=''
        message=""
      />
    );

    const inputs = result.container.querySelectorAll('input');
    expect(inputs.length).toEqual(1);
    expect(inputs[0].name).toEqual('csrf_token');

    const buttons = result.container.querySelectorAll('button');
    expect(buttons.length).toEqual(2);
    expect(buttons[0].name).toEqual('button');
    expect(buttons[0].value).toEqual('submit');
    expect(buttons[1].name).toEqual('button');
    expect(buttons[1].value).toEqual('cancel');
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

    it.each(methods)('%s: Requires `logout_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {};
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Logout challenge is missing',
        }
      });
    });

    it.each(methods)('%s: Rejects empty `logout_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = { logout_challenge: '' } as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Logout challenge is missing',
        },
      });
    });

    it.each(methods)('%s: Requires valid `logout_challenge`', async (method) => {
      (hydraAdmin.getLogoutRequest as jest.Mock).mockImplementation(() => {
        let e = new Error();
        e = Object.assign(e, { response: { status: 404 }});
        throw e;
      });

      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {logout_challenge: 'invalid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledWith('invalid');
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Logout challenge not found',
        },
      });
    });
  });

  describe('GET', () => {
    it('Renders form when `logout_challenge` is valid', async () => {
      (hydraAdmin.getLogoutRequest as jest.Mock).mockReturnValue({});

      const { req, res } = httpMocks.createMocks({
        method: 'GET',
        url: '/auth/sign-out?logout_challenge=valid'
      });
      const query = {logout_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLogoutRequest()
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledWith('valid');

      // check acceptLogoutRequest()
      expect(hydraAdmin.acceptLogoutRequest).toHaveBeenCalledTimes(0);

      // check result
      expect(result).toMatchObject({
        props: {
          action: '/auth/sign-out?logout_challenge=valid',
          message: ''
        }
      });
      expect(res.statusCode).toEqual(200);
    });    
  });

  describe('POST', () => {
    it('Rejects hydra logoutRequest when user clicks `cancel`', async () => {
      (hydraAdmin.getLogoutRequest as jest.Mock).mockReturnValue({});

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {button: 'cancel'},
      });
      const query = {logout_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLogoutRequest()                                                                                              
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledWith('valid');

      // check acceptLogoutRequest()                                                                                           
      expect(hydraAdmin.acceptLogoutRequest).toHaveBeenCalledTimes(0);

      // check rejectLogoutRequest()                                                                                           
      expect(hydraAdmin.rejectLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.rejectLogoutRequest).toHaveBeenCalledWith('valid');

      // check result                                                                                                          
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303
        }
      });
    });

    it('Accepts hydra logoutRequest when user clicks `submit`', async () => {
      (hydraAdmin.getLogoutRequest as jest.Mock).mockReturnValue({});
      (hydraAdmin.acceptLogoutRequest as jest.Mock).mockReturnValue({
        data: { redirect_to: '/redirect-url' }
      });

      const { req, res } = httpMocks.createMocks({ method: 'POST' });
      const query = { logout_challenge: 'valid' } as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getLogoutRequest()
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledWith('valid');

      // check rejectLogoutRequest()
      expect(hydraAdmin.rejectLogoutRequest).toHaveBeenCalledTimes(0);

      // check acceptLogoutRequest()
      expect(hydraAdmin.acceptLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.acceptLogoutRequest).toHaveBeenCalledWith('valid');

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