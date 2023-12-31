describe('HTTP response header tests', () => {
  it('should have performance headers present', async () => {
    const response = await cy.request('GET', '/');
    expect(response.headers).to.have.property('x-dns-prefetch-control', 'on');
  });
  
  it('should have security headers present', async () => {
    const securityHeaders = {
      'strict-transport-security': 'max-age=31536000 ; includeSubDomains',
      'x-frame-options': 'deny',
      'x-content-type-options': 'nosniff',
      'content-security-policy': "default-src 'self'; object-src 'none'; style-src 'unsafe-inline'; frame-ancestors 'none'; upgrade-insecure-requests; block-all-mixed-content",
      'x-permitted-cross-domain-policies': 'none',
      'referrer-policy': 'no-referrer',
      'cross-origin-embedder-policy': 'require-corp',
      'cross-origin-opener-policy': 'same-origin',
      'cross-origin-resource-policy': 'same-origin',
      'permissions-policy': 'accelerometer=(),autoplay=(),camera=(),display-capture=(),document-domain=(),encrypted-media=(),fullscreen=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),midi=(),payment=(),picture-in-picture=(),publickey-credentials-get=(),screen-wake-lock=(),sync-xhr=(self),usb=(),web-share=(),xr-spatial-tracking=()'
    };

    const response = await cy.request('GET', '/');
    for (const [key, val] of Object.entries(securityHeaders)) {
      cy.log(key);
      expect(response.headers).to.have.property(key, val);
    }
  });
});
