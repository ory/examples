import { render } from '@testing-library/react';
import type { GetServerSidePropsContext } from 'next';
import httpMocks from 'node-mocks-http';
import type { RequestMethod } from 'node-mocks-http';
import type { ParsedUrlQuery } from 'querystring';

import { hydraAdmin } from '@/lib/hydra';
import Consent, { getServerSideProps } from '@/pages/consent';
import { JSONWebKeySet } from '@ory/hydra-client';

jest.mock('@/lib/hydra');

describe('ConsentPage', () => {
  it('renders all form input elements', () => {
    const result = render(
      <Consent
        action=""
        csrfToken=""
        consentRequest={{challenge: '', requested_scope: ['scope_1', 'scope_2']}}
        message=""
      />
    );

    const inputs = result.container.querySelectorAll('input');
    expect(inputs.length).toEqual(4);
    expect(inputs[0].name).toEqual('csrf_token');
    expect(inputs[1].name).toEqual('grant_scope');
    expect(inputs[1].value).toEqual('scope_1');
    expect(inputs[2].name).toEqual('grant_scope');
    expect(inputs[2].value).toEqual('scope_2');
    expect(inputs[3].name).toEqual('remember');
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

    it.each(methods)('%s: Requires `consent_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {};
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Consent challenge is missing',
        },
      });
    });

    it.each(methods)('%s: Rejects empty `consent_challenge`', async (method) => {
      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = { consent_challenge: '' } as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Consent challenge is missing',
        },
      });
    });

    it.each(methods)('%s: Requires valid `consent_challenge`', async (method) => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockImplementation(() => {
        let e = new Error();
        e = Object.assign(e, { response: { status: 404 }});
        throw e;
      });

      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {consent_challenge: 'invalid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('invalid');
      expect(res.statusCode).toEqual(400);
      expect(result).toMatchObject({
        props: {
          message: 'Consent challenge not found',
        },
      });
    });

    it.each(methods)('%s: Accepts consent request when skip is true', async (method) => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockReturnValue({
        data: {
          skip: true,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      (hydraAdmin.acceptConsentRequest as jest.Mock).mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const { req, res } = httpMocks.createMocks({ method }, {});
      const query = {consent_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getConsentRequest()                                                                                             
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()                                                                                          
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledWith('valid', {
        grant_scope: ['scope_1', 'scope_2'],
        grant_access_token_audience: ['audience_1', 'audience_2'],
        session: {
          access_token: {key1: 'val1'},
          id_token: {key2: 'val2', email: 'name@example.com'}
        }
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

  describe('GET', () => {
    it('Renders form when `consent_challenge` is valid and skip is false', async () => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      const { req, res } = httpMocks.createMocks({
        method: 'GET',
        url: '/consent?consent_challenge=valid'
      });
      const query = {consent_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getConsentRequest()                                                                                             
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()                                                                                          
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(0);

      // check result                                                                                                          
      expect(result).toMatchObject({
        props: {
          action: '/consent?consent_challenge=valid',
          message: '',
          consentRequest: {
            skip: false,
            subject: 'name@example.com',
            requested_scope: ['scope_1', 'scope_2'],
            requested_access_token_audience: ['audience_1', 'audience_2'],
          }
        }
      });
      expect(res.statusCode).toEqual(200);
    });   
  });

  describe('POST', () => {
    it('Rejects hydra consentRequest when user clicks `reject`', async () => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      (hydraAdmin.rejectConsentRequest as jest.Mock).mockReturnValue({
        data: { redirect_to: '/redirect-url' }
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {button: 'reject'}
      });
      const query = {consent_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getConsentRequest()                                                                                             
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()                                                                                          
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(0);

      // check rejectConsentRequest()                                                                                          
      expect(hydraAdmin.rejectConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.rejectConsentRequest).toHaveBeenCalledWith('valid', {
        error: 'access_denied',
        error_description: 'The resource owner denied the request'
      });
      // check result                                                                                                          
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: '/redirect-url'
        }
      });
    });

    it('Accepts correct submissions with one scope', async () => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      (hydraAdmin.acceptConsentRequest as jest.Mock).mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {grant_scope: 'scope_1'}
      });
      const query = {consent_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getConsentRequest()                                                                                             
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()                                                                                          
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledWith('valid', {
        grant_scope: ['scope_1'],
        grant_access_token_audience: ['audience_1', 'audience_2'],
        session: {
          access_token: {key1: 'val1'},
          id_token: {key2: 'val2', email: 'name@example.com'}
        },
        remember: false,
        remember_for: 3600
      });

      // check result                                                                                                          
      expect(result).toMatchObject({
        redirect: {
          statusCode: 303,
          destination: '/redirect-url'
        }
      });
    });

    it('Accepts correct submissions with multiple scopes', async () => {
      (hydraAdmin.getConsentRequest as jest.Mock).mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      (hydraAdmin.acceptConsentRequest as jest.Mock).mockReturnValue({
        data: { redirect_to: '/redirect-url' }
      });

      const { req, res } = httpMocks.createMocks({
        method: 'POST',
        body: {grant_scope: ['scope_1', 'scope_2']}
      });
      const query = {consent_challenge: 'valid'} as ParsedUrlQuery;
      const result = await getServerSideProps({ req, res, query } as GetServerSidePropsContext);

      // check getConsentRequest()                                                                                             
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()                                                                                          
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledWith('valid', {
        grant_scope: ['scope_1', 'scope_2'],
        grant_access_token_audience: ['audience_1', 'audience_2'],
        session: {
          access_token: { key1: 'val1' },
          id_token: { key2: 'val2', email: 'name@example.com' }
        },
        remember: false,
        remember_for: 3600
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
