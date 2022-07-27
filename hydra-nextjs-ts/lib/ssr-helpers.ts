import { IncomingMessage } from 'http';
import type { GetServerSidePropsResult, Redirect } from 'next'
import { parseBody as nextParseBody } from 'next/dist/server/api-utils/node';
import { MockRequest } from 'node-mocks-http';
//import getRawBody from 'raw-body';

export function redirect(statusCode: 303 | 301 | 302 | 307 | 308, url: string): GetServerSidePropsResult<Redirect>  {
  return {
    redirect: {
      statusCode: statusCode,
      destination: url,
    },
  };
}

export async function parseBody(req: IncomingMessage | MockRequest<any>, limit: string = '1mb'): Promise<any> {
  if (req instanceof IncomingMessage) return await nextParseBody(req, limit);
  return req.body;
}
