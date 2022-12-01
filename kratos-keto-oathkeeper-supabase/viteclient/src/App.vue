<!-- Copyright © 2022 Ory Corp -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

<template>
  <!-- Container -->
  <div class="w-full min-h-screen bg-gray-100">
    <AppHeader
      :session="session"
      :signInURL="signInURL"
      :signUpURL="signUpURL"
      :logoutURL="logoutURL"
    />
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

      <URLInput :session="session" />
      <URLView />
    </div>
  </div>
</template>

<script lang="ts">
export default {
  name: 'AppPage',
  inheritAttrs: true,
};
</script>

<script setup lang="ts">
import { onMounted, Ref, ref } from 'vue';

import { Configuration, Session, V0alpha2Api } from '@ory/client';

import ShortsLogo from './components/ShortsLogo.vue';
import AppHeader from './components/AppHeader.vue';
import URLInput from './components/URLInput.vue';
import URLView from './components/URLView.vue';

const ory = new V0alpha2Api(
  new Configuration({
    basePath: import.meta.env.VITE_KRATOS_API_URL,
    baseOptions: {
      withCredentials: true,
    },
  })
);

const session: Ref<Session | null> = ref(null);

const logoutURL = ref('');

const APPHOME = import.meta.env.VITE_APPHOME;
const signInURL =
  import.meta.env.VITE_KRATOS_UI_URL + `/login?return_to=${APPHOME}`;

const signUpURL =
  import.meta.env.VITE_KRATOS_UI_URL + `/registration?return_to=${APPHOME}`;

onMounted(() => {
  // Fetch the session directly from Ory
  ory
    .toSession()
    .then(({ data }) => {
      session.value = data;

      // If the user is logged in, we want to show a logout link!
      ory.createSelfServiceLogoutFlowUrlForBrowsers().then(({ data }) => {
        logoutURL.value = data.logout_url + `?return_to=${APPHOME}`;
      });
    })
    .catch((err) => {
      console.log(err);
    });
});
</script>
