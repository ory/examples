import { getCookie } from "h3";
import { useRuntimeConfig } from "#imports";
import type { H3Event } from "h3";

export async function serverCheckAuth(event: H3Event) {
  const config = useRuntimeConfig();
  const cookie = getCookie(event, "ory_kratos_session");

  if (!cookie) {
    console.warn("No session cookie found");
    return null;
  }

  try {
    const response = await fetch(`${config.ORY_SDK_URL}/sessions/whoami`, {
      method: "GET",
      headers: {
        Cookie: `ory_kratos_session=${cookie}`,
        Accept: "application/json",
      },
    });

    if (!response.ok) {
      console.error(`HTTP error! status: ${response.status}`);
      return null;
    }

    return await response.json();
  } catch (error) {
    console.error("Error checking authentication:", error);
    return null;
  }
}
