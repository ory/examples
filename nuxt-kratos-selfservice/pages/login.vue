<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>Welcome Back</h1>
        <p>
          Don't have an account?
          <a @click="navigateTo('/signup')" class="link">Create today!</a>
        </p>
      </div>

      <KratosForm
        v-if="loginFlow"
        :flow="loginFlow"
        v-model:formData="formData"
        :isLoading="isLoading"
        submitButtonLabel="Sign In"
        submitButtonIcon="→"
        @submit="handleSubmit"
      >
        <template #additional-fields>
          <div class="additional-fields">
            <div class="remember-me">
              <input type="checkbox" id="rememberme" v-model="rememberMe">
              <label for="rememberme">Remember me</label>
            </div>
            <a
              class="forgot-password link"
              @click="navigateTo('/recovery')"
            >
              Forgot password?
            </a>
          </div>
        </template>
      </KratosForm>

      <button
        class="signup-button"
        :disabled="isLoading"
        @click="navigateTo('/signup')"
      >
        Sign Up
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue";
import { useAuth } from "~/composables/useAuth";
import KratosForm from "~/components/KratosForm.vue";

definePageMeta({
  guestOnly: true,
});

const { loginFlow, isLoading, error, clearError, initializeLoginFlow, login } = useAuth();

const formData = ref<Record<string, string>>({});
const rememberMe = ref(true);

onMounted(async () => {
  await initializeLoginFlow();
});

watch(error, (newError) => {
  if (newError) {
    alert(newError.message); // Replace with your preferred error handling method
    clearError();
  }
});

const handleSubmit = async () => {
  if (isLoading.value) return;

  const success = await login(formData.value);
  if (success) {
    alert("Login successful!"); // Replace with your preferred success handling method
    navigateTo("/");
  }
};
</script>

<style scoped>
.login-container {
  background-color: var(--color-background);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;
}

.login-box {
  background-color: var(--color-background-soft);
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.login-header h1 {
  font-size: 1.5rem;
  color: var(--color-heading);
  margin-bottom: 0.5rem;
}

.login-header p {
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

.additional-fields {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.remember-me {
  display: flex;
  align-items: center;
}

.remember-me input {
  margin-right: 0.5rem;
}

.forgot-password {
  font-size: 0.9rem;
}

.signup-button {
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

.signup-button:hover {
  background-color: var(--color-primary-dark);
}

.signup-button:disabled {
  background-color: var(--color-border);
  cursor: not-allowed;
}
</style>
