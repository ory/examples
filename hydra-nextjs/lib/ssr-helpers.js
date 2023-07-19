// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import { parseBody as nextParseBody } from "next/dist/server/api-utils/node"

export function redirect(statusCode, url) {
  return {
    redirect: {
      statusCode: statusCode,
      destination: url,
    },
  }
}

export function parseBody(req, limit) {
  // check cache
  if (req.body) return req.body

  // parse and cache
  const body = nextParseBody(req, limit || "1mb")
  req.body = body
  return body
}
