import { defineNuxtPlugin } from "#app";
import { Configuration, FrontendApi } from "@ory/kratos-client";

const createClient = (url: string) => {
  return new FrontendApi(
    new Configuration({
      basePath: url,
      baseOptions: {
        withCredentials: true,
      },
    })
  );
};

export default defineNuxtPlugin((nuxtApp) => {
  const config = useRuntimeConfig();
  const kratos = createClient(config.public.ORY_SDK_URL);

  return {
    provide: {
      kratos,
    },
  };
});
