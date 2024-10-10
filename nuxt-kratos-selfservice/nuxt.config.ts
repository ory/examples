export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  plugins: ["@/plugins/kratos.ts"],
  runtimeConfig: {
    ORY_SDK_URL: process.env.NUXT_ORY_SDK_URL || "http://kratos:4433",
    public: {
      ORY_SDK_URL:
        process.env.NUXT_PUBLIC_ORY_SDK_URL || "http://127.0.0.1:4433",
    },
  },
  server: {
    host: "0.0.0.0",
  },
});
