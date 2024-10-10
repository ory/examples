<template>
  <div class="signup-container">
    <div class="signup-box">
      <div class="signup-header">
        <h1>Create an Account</h1>
        <p>
          Already have an account?
          <a @click="navigateTo('/login')" class="link">Sign in!</a>
        </p>
      </div>

      <KratosForm
        v-if="flow"
        :flow="flow"
        v-model:formData="formData"
        :isLoading="isLoading"
        submitButtonLabel="Register"
        submitButtonIcon="→"
        @submit="handleSubmit"
      >
        <template #additional-fields>
          <div class="form-group">
            <label for="password_repeat">Repeat Password</label>
            <input
              id="password_repeat"
              v-model="passwordRepeat"
              type="password"
              placeholder="Repeat your password"
              :class="{ 'input-error': passwordMismatch }"
              required
            />
            <small v-if="passwordMismatch" class="error-message">
              Passwords do not match
            </small>
          </div>
        </template>
      </KratosForm>

      <button
        class="signin-button"
        :disabled="isLoading"
        @click="navigateTo('/login')"
      >
        Sign In
      </button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import {
  Configuration,
  FrontendApi,
  type RegistrationFlow,
} from "@ory/kratos-client";
import { ref, onMounted, computed } from "vue";
import KratosForm from "~/components/KratosForm.vue";

definePageMeta({
  guestOnly: true,
});

const config = useRuntimeConfig();

const ory = new FrontendApi(
  new Configuration({
    basePath: config.public.ORY_SDK_URL,
    baseOptions: {
      withCredentials: true,
    },
  })
);

const flow = ref<RegistrationFlow | null>(null);
const formData = ref<Record<string, string>>({});
const passwordRepeat = ref("");
const isLoading = ref(false);

const passwordMismatch = computed(() => {
  return formData.value["password"] !== passwordRepeat.value;
});

onMounted(() => {
  ory
    .createBrowserRegistrationFlow()
    .then(({ data }) => {
      flow.value = data;
      flow.value.ui.nodes.forEach((node) => {
        if ("name" in node.attributes) {
          formData.value[node.attributes.name] = "";
        }
      });
    })
    .catch((err) => {
      alert("Failed to initialize registration flow. Please try again.");
    });
});

const handleSubmit = () => {
  if (isLoading.value || !flow.value || passwordMismatch.value) return;

  isLoading.value = true;

  const submitData = {
    ...formData.value,
    ...Object.fromEntries(
      flow.value.ui.nodes
        .filter(
          (node) => node.type === "input" && node.attributes.type === "hidden"
        )
        .map((node) => [node.attributes.name, node.attributes.value])
    ),
  };

  ory
    .updateRegistrationFlow({
      flow: flow.value.id,
      updateRegistrationFlowBody: { ...submitData, method: "password" },
    })
    .then(({ data }) => {
      console.log("success", data);
      alert("You are signed up!");
      navigateTo("/login");
    })
    .catch((error) => {
      console.log("error", error);
      alert("An error occurred during registration. Please try again.");
    })
    .finally(() => {
      isLoading.value = false;
    });
};
</script>

<style scoped>
.signup-container {
  background-color: var(--color-background);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;
}

.signup-box {
  background-color: var(--color-background-soft);
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.signup-header {
  text-align: center;
  margin-bottom: 2rem;
}

.signup-header h1 {
  font-size: 1.5rem;
  color: var(--color-heading);
  margin-bottom: 0.5rem;
}

.signup-header p {
  color: var(--color-text);
}

.link {
  color: var(--color-primary);
  cursor: pointer;
  text-decoration: none;
}

.link:hover {
  text-decoration: underline;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--color-text);
}

.form-group input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  font-size: 1rem;
}

.input-error {
  border-color: var(--color-danger);
}

.error-message {
  color: var(--color-danger);
  font-size: 0.875rem;
  margin-top: 0.25rem;
}

.signin-button {
  width: 100%;
  padding: 0.75rem;
  background-color: var(--color-primary);
  color: var(--color-background);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
  margin-top: 1rem;
  transition: background-color 0.3s ease;
}

.signin-button:hover {
  background-color: var(--color-primary-dark);
}

.signin-button:disabled {
  background-color: var(--color-border);
  cursor: not-allowed;
}
</style>
