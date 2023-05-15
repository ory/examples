// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0
import { Session } from "@ory/client"

declare module "express" {
  export interface Request {
    session?: Session
  }
}
