// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0
import {
  Configuration,
  FrontendApi,
  IdentityApi,
  OAuth2Api,
  PermissionApi,
} from "@ory/client"

const baseUrlInternal =
  process.env.ORY_SDK_URL || "https://playground.projects.oryapis.com"

const apiBaseFrontendUrlInternal =
  process.env.KRATOS_PUBLIC_URL || baseUrlInternal

const apiBaseOauth2UrlInternal = process.env.HYDRA_ADMIN_URL || baseUrlInternal

const apiBaseIdentityUrlInternal =
  process.env.KRATOS_ADMIN_URL || baseUrlInternal

const apiBasePermissionUrlInternal =
  process.env.KETO_READ_URL || baseUrlInternal

export const apiBaseUrl =
  process.env.KRATOS_BROWSER_URL || apiBaseFrontendUrlInternal

const hydraBaseOptions: any = {}

if (process.env.MOCK_TLS_TERMINATION) {
  hydraBaseOptions.headers = { "X-Forwarded-Proto": "https" }
}

// Sets up the SDK
const sdk = {
  basePath: apiBaseFrontendUrlInternal,
  frontend: new FrontendApi(
    new Configuration({
      basePath: apiBaseFrontendUrlInternal,
    }),
  ),
  oauth2: new OAuth2Api(
    new Configuration({
      basePath: apiBaseOauth2UrlInternal,
      baseOptions: hydraBaseOptions,
    }),
  ),
  identity: new IdentityApi(
    new Configuration({
      basePath: apiBaseIdentityUrlInternal,
    }),
  ),
  permission: new PermissionApi(
    new Configuration({
      basePath: apiBasePermissionUrlInternal,
    }),
  ),
}

export default sdk
