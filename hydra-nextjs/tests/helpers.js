import http from 'http';

export function mockRequest(options) {
  let req = new http.IncomingMessage();

  const { body, ...attrs } = options || {};
  req = Object.assign(req, attrs);

  // write body
  req.push(body || '');
  req.push(null);

  return req;
}

export function mockResponse(options) {
  return new http.ServerResponse(options || {});
}
