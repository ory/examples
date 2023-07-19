// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

export default function handler(req, res) {
  res.status(403).send("invalid csrf token")
}
