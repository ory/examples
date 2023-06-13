import '@testing-library/jest-dom';
import { render, screen } from '@testing-library/react';

import { hydraAdmin } from '../../lib/hydra';
import SignOut, { getServerSideProps } from '../../pages/auth/sign-out';

import { mockRequest, mockResponse } from '../helpers';

jest.mock('../../lib/hydra');

describe('SignOutPage', () => {
  it('renders all form input elements', () => {
    const result = render(
      <SignOut
        action=""
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
    const req = mockRequest({method: 'OTHER'});
    const result = await getServerSideProps({ req });
    expect(result.notFound).toEqual(true);
  });

  describe('GET and POST', () => {
    const methods = ['GET', 'POST'];

    it.each(methods)('%s: Requires `logout_challenge`', async (method) => {
      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {};
      const result = await getServerSideProps({ req, res, query });
      expect(result.props.message).toEqual('Logout challenge is missing');
      expect(res.statusCode).toEqual(400);
    });

    it.each(methods)('%s: Rejects empty `logout_challenge`', async (method) => {
      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {consent_challenge: ''};
      const result = await getServerSideProps({ req, res, query });
      expect(result.props.message).toEqual('Logout challenge is missing');
      expect(res.statusCode).toEqual(400);
    });

    it.each(methods)('%s: Requires valid `logout_challenge`', async (method) => {
      hydraAdmin.getLogoutRequest = jest.fn(() => {
        let e = new Error();
        e.response = {status: 404};
        throw e;
      });

      const req = mockRequest({ method });
      const res = mockResponse();
      const query = {logout_challenge: 'invalid'};
      const result = await getServerSideProps({ req, res, query });

      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledTimes(1);
      expect(hydraAdmin.getLogoutRequest).toHaveBeenCalledWith('invalid');
      expect(result.props.message).toEqual('Logout challenge not found');
      expect(res.statusCode).toEqual(400);
    });
  });

  describe('GET', () => {
    it('Renders form when `logout_challenge` is valid', async () => {
      hydraAdmin.getLogoutRequest.mockReturnValue({});

      const req = mockRequest({
        method: 'GET',
        url: '/auth/sign-out?logout_challenge=valid'
      });
      const res = mockResponse();
      const query = {logout_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

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
    it('Rejects hydra logoutRequest when user clicks `reject`', async () => {
      hydraAdmin.getLogoutRequest.mockReturnValue({});

      const req = mockRequest({
        method: 'POST',
        headers: {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'button=cancel'
      });
      const res = mockResponse();
      const query = {logout_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

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
      hydraAdmin.getLogoutRequest.mockReturnValue({});
      hydraAdmin.acceptLogoutRequest.mockReturnValue({
        data: {redirect_to: '/redirect-url'}
      });

      const req = mockRequest({
        method: 'POST',
        headers: {
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
      });
      const res = mockResponse();
      const query = {logout_challenge: 'valid'};
      const result = await getServerSideProps({ req, res, query });

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
