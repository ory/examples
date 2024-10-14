import { serverCheckAuth } from "~/server/utils/checkAuth";
import { useAuth } from "~/composables/useAuth";
import type { RouteLocationNormalizedGeneric } from "vue-router";

export default defineNuxtRouteMiddleware(async (to) => {
  if (import.meta.server) {
    if (!to.path.startsWith("/api")) {
      return;
    }

    const event = useRequestEvent();
    if (!event) {
      return;
    }
    const session = await serverCheckAuth(event);

    return checkRoute(session, to);
  }

  if (import.meta.client) {
    const { checkAuth, isAuthenticated, isLoading } = useAuth();

    await checkAuth();

    if (isLoading.value) {
      return;
    }

    return checkRoute(isAuthenticated.value, to);
  }
});

const checkRoute = (
  session: boolean,
  route: RouteLocationNormalizedGeneric
) => {
  if (
    !session &&
    route.meta.requiresAuth !== false &&
    route.meta.guestOnly !== true
  ) {
    return navigateTo("/login");
  }

  if (session && route.meta.guestOnly) {
    return navigateTo("/");
  }

  return;
};
