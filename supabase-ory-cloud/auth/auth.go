// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package auth

type (
	AccessControl interface {
		GrantAccess(string, string) error
		CheckAccess(string, string) error
	}
)
