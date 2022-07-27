import '@testing-library/jest-dom';
import { render, screen } from '@testing-library/react';

import { hydraAdmin } from '../../lib/hydra';
import Consent, { getServerSideProps } from '../../pages/auth/consent';

import { mockRequest, mockResponse } from '../helpers';

jest.mock('../../lib/hydra');

describe('ContentPage', () => {
  it('renders all form input elements', () => {
    const result = render(
      <Consent
        action=""
        consentRequest={{requested_scope: ['scope_1', 'scope_2']}}
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
    const req = mockRequest({method: 'OTHER'});
    const result = await getServerSideProps({ req });
    expect(result.notFound).toEqual(true);
  });

  describe('GET and POST', () => {
    const methods = ['GET', 'POST'];

    it.each(methods)('%s: Requires `consent_challenge`', async (method) => {
      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {};
      const result = await getServerSideProps({ req, res, query });
      expect(result.props.message).toEqual('Consent challenge is missing');
      expect(res.statusCode).toEqual(400);
    });

    it.each(methods)('%s: Rejects empty `consent_challenge`', async (method) => {
      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {consent_challenge: ''};
      const result = await getServerSideProps({ req, res, query });
      expect(result.props.message).toEqual('Consent challenge is missing');
      expect(res.statusCode).toEqual(400);
    });

    it.each(methods)('%s: Requires valid `consent_challenge`', async (method) => {
      hydraAdmin.getConsentRequest = jest.fn(() => {
        let e = new Error();
        e.response = {status: 404};
        throw e;
      });

      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {consent_challenge: 'invalid'};
      const result = await getServerSideProps({ req, res, query });

      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('invalid');
      expect(result.props.message).toEqual('Consent challenge not found');
      expect(res.statusCode).toEqual(400);
    });

    it.each(methods)('%s: Accepts consent request when skip is true', async (method) => {
      hydraAdmin.getConsentRequest.mockReturnValue({
        data: {
          skip: true,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      hydraAdmin.acceptConsentRequest.mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const req = mockRequest({ method });
      const res = mockResponse();
      const query = { consent_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

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
      hydraAdmin.getConsentRequest.mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      const req = mockRequest({
        method: 'GET',
        url: '/auth/consent?consent_challenge=valid'
      });
      const res = mockResponse();
      const query = {consent_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

      // check getConsentRequest()
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getConsentRequest).toHaveBeenCalledWith('valid');

      // check acceptConsentRequest()
      expect(hydraAdmin.acceptConsentRequest).toHaveBeenCalledTimes(0);

      // check result
      expect(result).toMatchObject({
        props: {
          action: '/auth/consent?consent_challenge=valid',
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
      hydraAdmin.getConsentRequest.mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      hydraAdmin.rejectConsentRequest.mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const req = mockRequest({
        method: 'POST',
        headers: {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'button=reject'
      });
      const res = mockResponse();
      const query = {consent_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

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
      hydraAdmin.getConsentRequest.mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      hydraAdmin.acceptConsentRequest.mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const req = mockRequest({
        method: 'POST',
        headers: {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'grant_scope=scope_1'
      });
      const res = mockResponse();
      const query = {consent_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });
      
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
      hydraAdmin.getConsentRequest.mockReturnValue({
        data: {
          skip: false,
          subject: 'name@example.com',
          requested_scope: ['scope_1', 'scope_2'],
          requested_access_token_audience: ['audience_1', 'audience_2'],
        }
      });

      hydraAdmin.acceptConsentRequest.mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const req = mockRequest({
        method: 'POST',
        headers: {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'grant_scope=scope_1&grant_scope=scope_2'
      });
      const res = mockResponse();
      const query = {consent_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });
      
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
