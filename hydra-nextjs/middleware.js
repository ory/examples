// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import csrf from "edge-csrf"
import { NextResponse } from "next/server"

// initialize csrf protection function
const csrfProtect = csrf()

export async function middleware(request) {
  const response = NextResponse.next()

  // csrf protection
  const csrfError = await csrfProtect(request, response)

  // check result
  if (csrfError) {
    const url = request.nextUrl.clone()
    url.pathname = "/api/csrf-invalid"
    return NextResponse.rewrite(url)
  }

  return response
}
