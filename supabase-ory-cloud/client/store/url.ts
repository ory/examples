export const state = () => ({
  urls: [],
})

export const mutations = {
  add (state, url) {
    state.urls.push(url)
  },
  remove (state, url) {
    state.urls.splice(state.urls.indexOf(url), 1)
  },
}

