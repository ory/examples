import csrf from 'edge-csrf';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const csrfProtect = csrf();

export async function middleware(request: NextRequest) {
  const response = NextResponse.next();

  // csrf protection
  const csrfError = await csrfProtect(request, response);

  // check result
  if (csrfError) {
    const url = request.nextUrl.clone();
    url.pathname = '/api/csrf-invalid';
    return NextResponse.rewrite(url);
  }

  return response;
}
