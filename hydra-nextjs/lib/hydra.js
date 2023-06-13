import { AdminApi, Configuration } from '@ory/hydra-client';

const hydraAdmin = new AdminApi(
  new Configuration({
    basePath: process.env.HYDRA_ADMIN_URL
  })
);

export { hydraAdmin };
