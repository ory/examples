<template>
  <!-- Container -->
  <div class="w-full min-h-screen bg-gray-100">
    <AppHeader />
    <div
      class="max-w-2xl mx-auto flex flex-col items-center justify-center px-4"
    >
      <!-- Logo Image -->
      <ShortsLogo />
      <!-- Header -->
      <h1 class="text-gray-900 font-black text-5xl uppercase text-center">
        Shorts
      </h1>
      <h2 class="text-indigo-700 text-sm font-semibold italic">
        Make your URLs shorter!
      </h2>

      <URLInput />
      <URLView />

    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { Configuration, V0alpha2Api } from '@ory/kratos-client'
import type { SelfServiceLogoutUrl } from '@ory/kratos-client'
import type { AxiosResponse } from 'axios'
import AppHeader from '../components/AppHeader'

const getLogoutURL = async ({ app }) => {
  const ory = new V0alpha2Api(
    new Configuration({
      basePath: app.$config.kratosAPIURL,
      baseOptions: {
        withCredentials: true
      }
    })
  )
  try {
    const data = await ory.createSelfServiceLogoutFlowUrlForBrowsers()
    return data
  } catch {
    return {
      data: {
        logout_url: ''
      }
    }
  }
}

const getAuthState = async ({ app }) => {
  const ory = new V0alpha2Api(
    new Configuration({
      basePath: app.$config.kratosAPIURL,
      baseOptions: {
        withCredentials: true
      }
    })
  )

  try {
    const session = await ory.toSession()
    return {
      authenticated: true,
      session: session,
    }
  } catch {
    return {
      authenticated: false,
      session: {},
    }
  }
}

export default Vue.extend({
  name: 'IndexPage',
  async asyncData (context) {
    const authState = await getAuthState(context)
    const logoutData = await getLogoutURL(context)
    context.store.commit('session/setSession', authState.session.data)
    context.store.commit('session/setAuthenticated', authState.authenticated)
    context.store.commit('session/setLogoutURL', logoutData.data.logout_url)
  }
})
</script>
