// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package config

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParse(t *testing.T) {
	os.Setenv("DSN", "Hello")

	c, err := Parse()
	assert.NoError(t, err)
	assert.Equal(t, 8, c.URLLength)
	assert.Equal(t, ":8090", c.BindAddr)
	assert.Equal(t, "Hello", c.DSN)
	assert.Equal(t, false, c.TestMode)
}
