// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package database

import (
	"crypto/sha1"
	"encoding/hex"
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

func generateSHA1(s string) string {
	h := sha1.New()
	h.Write([]byte(s))
	return hex.EncodeToString(h.Sum(nil))
}
