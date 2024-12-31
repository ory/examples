import { ref, readonly, onMounted } from "vue";
import type {
  Session,
  LoginFlow,
  RegistrationFlow,
  UpdateLoginFlowBody,
  UpdateRegistrationFlowBody,
} from "@ory/kratos-client";

interface AuthError {
  message: string;
  details?: Record<string, any>;
}

interface User {
  id: string;
  email: string;
}

export const useAuth = () => {
  const { $kratos } = useNuxtApp();

  const user = ref<User | null>(null);
  const isAuthenticated = ref(false);
  const isLoading = ref(true);
  const error = ref<AuthError | null>(null);
  const loginFlow = ref<LoginFlow | null>(null);
  const registrationFlow = ref<RegistrationFlow | null>(null);

  const setUser = (session: Session) => {
    if (!session.identity) {
      user.value = null;
      isAuthenticated.value = false;
      return;
    }

    user.value = {
      id: session.identity.id,
      email: session.identity.traits.email,
    };
    isAuthenticated.value = true;
  };

  const handleError = (err: unknown): AuthError => {
    if (err instanceof Error) {
      return { message: err.message };
    }
    if (typeof err === "object" && err !== null && "response" in err) {
      const errorResponse = (err as any).response?.data;
      if (errorResponse && typeof errorResponse === "object") {
        return {
          message: errorResponse.error?.message || "An unknown error occurred",
          details: errorResponse.error?.details,
        };
      }
    }
    return { message: "An unknown error occurred" };
  };

  const checkAuth = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const { data: session } = await $kratos.toSession();
      setUser(session);
    } catch (err) {
      error.value = handleError(err);
      isAuthenticated.value = false;
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  };

  const initializeLoginFlow = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const { data } = await $kratos.createBrowserLoginFlow();
      loginFlow.value = data;
    } catch (err) {
      error.value = handleError(err);
    } finally {
      isLoading.value = false;
    }
  };

  const login = async (updateLoginFlowBody: UpdateLoginFlowBody) => {
    isLoading.value = true;
    error.value = null;
    try {
      if (!loginFlow.value) {
        throw new Error("Login flow not initialized");
      }
      const { data: successfulNativeLogin } = await $kratos.updateLoginFlow({
        flow: loginFlow.value.id,
        updateLoginFlowBody,
      });
      setUser(successfulNativeLogin.session);
      return true;
    } catch (err) {
      error.value = handleError(err);
      return false;
    } finally {
      isLoading.value = false;
    }
  };

  const logout = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      await $kratos.createBrowserLogoutFlow();
      isAuthenticated.value = false;
      user.value = null;
      return navigateTo("/login");
    } catch (err) {
      error.value = handleError(err);
    } finally {
      isLoading.value = false;
    }
  };

  const initializeRegistrationFlow = async () => {
    isLoading.value = true;
    error.value = null;
    try {
      const { data } = await $kratos.createBrowserRegistrationFlow();
      registrationFlow.value = data;
    } catch (err) {
      error.value = handleError(err);
    } finally {
      isLoading.value = false;
    }
  };

  const register = async (
    updateRegistrationFlowBody: UpdateRegistrationFlowBody
  ) => {
    isLoading.value = true;
    error.value = null;
    try {
      if (!registrationFlow.value) {
        throw new Error("Registration flow not initialized");
      }
      const { data: successfulNativeRegistration } =
        await $kratos.updateRegistrationFlow({
          flow: registrationFlow.value.id,
          updateRegistrationFlowBody,
        });

      if (!successfulNativeRegistration.session) {
        error.value = {
          message: "Registration successful but no session created",
        };
        return false;
      }
      setUser(successfulNativeRegistration.session);
      return true;
    } catch (err) {
      error.value = handleError(err);
      return false;
    } finally {
      isLoading.value = false;
    }
  };

  const clearError = () => {
    error.value = null;
  };

  return {
    user: readonly(user),
    isAuthenticated: readonly(isAuthenticated),
    isLoading: readonly(isLoading),
    error: readonly(error),
    loginFlow: readonly(loginFlow),
    registrationFlow: readonly(registrationFlow),
    checkAuth,
    initializeLoginFlow,
    login,
    logout,
    initializeRegistrationFlow,
    register,
    clearError,
  };
};
