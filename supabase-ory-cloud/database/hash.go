// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package database

import (
	"math/rand"
	"time"
)

var alphabet = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")

func generateHash(l int) string {
	rand.Seed(time.Now().UnixNano())
	b := make([]rune, l)
	for i := range b {
		b[i] = alphabet[rand.Intn(len(alphabet))]
	}
	return string(b)
}
