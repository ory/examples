import { defineNuxtPlugin } from "#app";
import { Configuration, FrontendApi } from "@ory/kratos-client";

const kratos = {
  public: {},
  api: {},
} as {
  public: FrontendApi;
  api: FrontendApi;
};

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

  if (!kratos.public) {
    kratos.public = createClient(config.public.ORY_SDK_URL);
  }

  if (!kratos.api) {
    kratos.api = createClient(config.ORY_SDK_URL);
  }

  return {
    provide: {
      kratos,
    },
  };
});
