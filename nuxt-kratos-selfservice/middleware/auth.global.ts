import { serverCheckAuth } from "~/server/utils/checkAuth";
import { useAuth } from "~/composables/useAuth";

export default defineNuxtRouteMiddleware(async (to) => {
  if (import.meta.server) {
    const event = useRequestEvent();
    if (!event) {
      console.error('Request event is undefined');
      return;
    }

    try {
      const session = await serverCheckAuth(event);
      if (!session && to.meta.requiresAuth !== false && to.meta.guestOnly !== true) {
        return navigateTo("/login");
      }
      if (session && to.meta.guestOnly) {
        return navigateTo("/");
      }
    } catch (error) {
      console.error('Server-side auth check failed:', error);
      return navigateTo("/login");
    }
  } else {
    const { checkAuth, isAuthenticated, isLoading } = useAuth();
    
    await checkAuth();

    if (isLoading.value) {
      return;
    }

    if (to.meta.requiresAuth !== false && to.meta.guestOnly !== true && !isAuthenticated.value) {
      return navigateTo("/login");
    }

    if (to.meta.guestOnly && isAuthenticated.value) {
      return navigateTo("/");
    }
  }
});
