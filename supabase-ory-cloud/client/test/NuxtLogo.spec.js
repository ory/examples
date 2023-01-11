// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import { mount } from "@vue/test-utils"
import NuxtLogo from "@/components/NuxtLogo.vue"

describe("NuxtLogo", () => {
  test("is a Vue instance", () => {
    const wrapper = mount(NuxtLogo)
    expect(wrapper.vm).toBeTruthy()
  })
})
