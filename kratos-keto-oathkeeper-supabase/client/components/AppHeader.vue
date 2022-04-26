<template>
  <div>
    <div class="bg-gray-100">
      <nav
        class="
          container
          px-6
          py-8
          mx-auto
          md:flex md:justify-between md:items-center
        "
      >
        <div class="flex items-center justify-between">
          <router-link
            to="/"
            class="
              text-xl
              font-bold
              text-gray-800
              md:text-2xl
              hover:text-blue-400
            "
          >Shorts
          </router-link>
          <!-- Mobile menu button -->
          <div @click="showMenu = !showMenu" class="flex md:hidden">
            <button
              type="button"
              class="
                text-gray-800
                hover:text-gray-400
                focus:outline-none focus:text-gray-400
              "
            >
              <svg viewBox="0 0 24 24" class="w-6 h-6 fill-current">
                <path
                  fill-rule="evenodd"
                  d="M4 5h16a1 1 0 0 1 0 2H4a1 1 0 1 1 0-2zm0 6h16a1 1 0 0 1 0 2H4a1 1 0 0 1 0-2zm0 6h16a1 1 0 0 1 0 2H4a1 1 0 0 1 0-2z"
                ></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Mobile Menu open: "block", Menu closed: "hidden" -->
        <ul
          :class="showMenu ? 'flex' : 'hidden'"
          class="
            flex-col
            mt-8
            space-y-4
            md:flex
            md:space-y-0
            md:flex-row
            md:items-center
            md:space-x-10
            md:mt-0
          "
        >
          <li class="text-sm font-bold text-gray-800 hover:text-blue-400">
            Home
          </li>
          <li v-if="!authenticated" class="text-sm font-bold text-gray-800 hover:text-blue-400">
            <a :href="$config.kratosUI + '/login'">
              Sign in
            </a>
          </li>
          <li v-if="!authenticated" class="text-sm font-bold text-gray-800 hover:text-blue-400">
            <a :href="$config.kratosUI + '/registration'">
              Sign Up
            </a>
          </li>
          <li v-if="authenticated" class="text-sm font-bold text-gray-800 hover:text-blue-400">
            <a :href="logoutURL">
              Logout
            </a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>
<script>
export default {
  name: 'AppHeader',
  computed: {
    authenticated() {
      return this.$store.state.session.authenticated
    },
    session() {
      return this.$store.state.session.session
    },
    logoutURL() {
      return this.$store.state.session.logoutURL
    }
  },
  data () {
    return {
      showMenu: false
    }
  }
}
</script>
