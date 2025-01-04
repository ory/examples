import { getCookie } from "h3";
import { useRuntimeConfig } from "#imports";
import type { H3Event } from "h3";
import { Configuration, FrontendApi } from "@ory/kratos-client";

const createKratosClient = (basePath: string) =>
  new FrontendApi(
    new Configuration({
      basePath,
    })
  );

export async function serverCheckAuth(event: H3Event) {
  const config = useRuntimeConfig();
  const cookie = getCookie(event, "ory_kratos_session");
  const client = createKratosClient(config.ORY_SDK_URL);

  return client
    .toSession({
      xSessionToken: cookie,
    })
    .then(({ data, status }) => {
      if (status !== 200) {
        console.error(`HTTP error! status: ${status}`);
        return false;
      }
      return !!data.active && !!data.id && !!data.identity;
    })
    .catch((error) => {
      console.error("Error checking authentication:", error);
      return false;
    });
}
