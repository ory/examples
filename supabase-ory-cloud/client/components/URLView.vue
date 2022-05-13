<template>
	<div class="py-6 w-full">
		<div
				class="my-3 bg-white shadow rounded-lg"
				v-for="(shortenedUrl, index) in shortenedUrls"
				:key="index"
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
							<h3 class=" px-2 text-lg leading-6 font-semibold text-gray-900">
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
                v-bind:href="shortened(shortenedUrl.hash)"
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
<script>
export default {
  name: 'URLView',
  async fetch () {
    try {
      this.shortenedUrls = await this.$axios.$get('/api/url')
    } catch {
      console.log("API is offline")
    }
  },
  methods: {
    shortened (hash) {
      return this.$config.baseURL + '/u/' + hash
    }
  },
  data() {
    return {
      shortenedUrls: []
    }
  }
}
</script>
