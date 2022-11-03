// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

export const state = () => ({
  urls: [],
})

export const mutations = {
  add(state, url) {
    state.urls.push(url)
  },
  remove(state, url) {
    state.urls.splice(state.urls.indexOf(url), 1)
  },
}
