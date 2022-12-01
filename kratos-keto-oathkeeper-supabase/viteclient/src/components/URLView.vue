<!-- Copyright © 2022 Ory Corp -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

<template>
  <div class="py-6 w-full">
    <div
      v-for="(shortenedUrl, index) in shortenedUrls"
      :key="index"
      class="my-3 bg-white shadow rounded-lg"
    >
      <div class="px-4 py-5 sm:p-6">
        <div class="flex items-center">
          <svg
            class="h-5 w-5 text-green-600"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"
            />
          </svg>
          <h3 class="px-2 text-lg leading-6 font-semibold text-gray-900">
            Your Shortened Url
          </h3>
        </div>
        <div
          class="mt-2 max-w-xl text-xs font-medium leading-5 text-gray-500 overflow-hidden"
        >
          <p>
            {{ shortenedUrl.url }}
          </p>
        </div>

        <div class="mt-3 text-sm leading-5">
          <a
            :href="shortenedUrl.shortened"
            target="_blank"
            class="font-medium text-indigo-600 hover:text-indigo-500 transition ease-in-out duration-150"
          >
            {{ shortenedUrl.hash }} &rarr;
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';

type URLModel = {
  url: string;
  shortened: string;
  hash: string;
};

const shortenedUrls: URLModel[] = [];

const LINKS_URL = import.meta.env.VITE_API_BASE_URL + '/api/url';

onMounted(() => {
  fetch(LINKS_URL)
    .then((r) => r.json())
    .then((res) => console.log(res));
});
</script>
