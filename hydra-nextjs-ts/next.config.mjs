/** @type {import('next').NextConfig} */
import yn from 'yn';

let headers = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
];

// security headers (https://owasp.org/www-project-secure-headers/)
if (yn(process.env.SECURITY_HEADERS_ENABLE) === true) {
  headers.push(...[
    {
      key: 'Strict-Transport-Security',
      value: 'max-age=31536000 ; includeSubDomains'
    },
    {
      key: 'X-Frame-Options',
      value: 'deny'
    },
    {
      key: 'X-Content-Type-Options',
      value: 'nosniff'
    },
    {
      key: 'Content-Security-Policy',
      value: "default-src 'self'; object-src 'none'; style-src 'unsafe-inline'; frame-ancestors 'none'; upgrade-insecure-requests; block-all-mixed-content"
    },
    {
      key: 'X-Permitted-Cross-Domain-Policies',
      value: 'none'
    },
    {
      key: 'Referrer-Policy',
      value: 'no-referrer'
    },
    {
      key: 'Cross-Origin-Embedder-Policy',
      value: 'require-corp'
    },
    {
      key: 'Cross-Origin-Opener-Policy',
      value: 'same-origin'
    },
    {
      key: 'Cross-Origin-Resource-Policy',
      value: 'same-origin'
    },
    {
      key: 'Permissions-Policy',
      value: 'accelerometer=(),autoplay=(),camera=(),display-capture=(),document-domain=(),encrypted-media=(),fullscreen=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),midi=(),payment=(),picture-in-picture=(),publickey-credentials-get=(),screen-wake-lock=(),sync-xhr=(self),usb=(),web-share=(),xr-spatial-tracking=()'
    },
  ]);
}

const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  webpack5: true,
  webpack: (config) => {
    // fixes npm packages that depend on `fs` module
    config.resolve.fallback = { fs: false };
    return config;
  },
  async headers() {
    return [
      {
        source: '/:path*',
        headers: headers
      }
    ];
  }
};

export default nextConfig;
