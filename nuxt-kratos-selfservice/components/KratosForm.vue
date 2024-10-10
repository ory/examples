<template>
  <form @submit.prevent="handleSubmit" class="kratos-form">
    <template v-for="node in flow.ui.nodes" :key="node.attributes.id">
      <div v-if="isVisibleField(node)" class="form-group">
        <label :for="node.attributes.id" class="form-label">
          {{ node.meta.label?.text }}
        </label>
        <input
          v-if="['text', 'password', 'email'].includes(node.attributes.type)"
          :id="node.attributes.id"
          :name="node.attributes.name"
          v-model="formData[node.attributes.name]"
          :type="node.attributes.type"
          :placeholder="node.meta.label?.text"
          class="form-input"
          :class="{ 'input-error': hasError(node) }"
          :required="node.attributes.required"
        />
        <select
          v-else-if="node.attributes.type === 'select'"
          :id="node.attributes.id"
          :name="node.attributes.name"
          v-model="formData[node.attributes.name]"
          class="form-select"
          :class="{ 'input-error': hasError(node) }"
          :required="node.attributes.required"
        >
          <option value="" disabled selected>
            {{ node.meta.label?.text }}
          </option>
          <option
            v-for="option in node.attributes.options"
            :key="option.value"
            :value="option.value"
          >
            {{ option.label }}
          </option>
        </select>
        <small v-if="hasError(node)" class="error-message">
          {{ getErrorMessage(node) }}
        </small>
      </div>
      <input
        v-else-if="isHiddenField(node)"
        :id="node.attributes.id"
        :name="node.attributes.name"
        :value="node.attributes.value"
        type="hidden"
      />
    </template>

    <div v-if="!hasPasswordField" class="form-group">
      <label for="password" class="form-label">Password</label>
      <input
        id="password"
        v-model="formData.password"
        type="password"
        class="form-input"
        required
      />
    </div>

    <slot name="additional-fields"></slot>

    <button
      type="submit"
      class="submit-button"
      :disabled="isLoading || !isFormValid"
    >
      <span v-if="submitButtonIcon" class="button-icon">{{
        submitButtonIcon
      }}</span>
      {{ submitButtonLabel }}
    </button>
  </form>
</template>

<script lang="ts" setup>
import { computed, watch } from "vue";
import type { UiNode, UiFlow } from "@ory/kratos-client";

const props = defineProps<{
  flow: UiFlow;
  formData: Record<string, string>;
  isLoading: boolean;
  submitButtonLabel: string;
  submitButtonIcon?: string;
}>();

const emit = defineEmits(["submit", "update:formData"]);

const isVisibleField = (node: UiNode) => {
  return node.type === "input" && node.attributes.type !== "hidden";
};

const isHiddenField = (node: UiNode) => {
  return node.type === "input" && node.attributes.type === "hidden";
};

const hasError = (node: UiNode) => {
  return node.messages && node.messages.length > 0;
};

const getErrorMessage = (node: UiNode) => {
  return node.messages && node.messages.length > 0 ? node.messages[0].text : "";
};

const hasPasswordField = computed(() => {
  return props.flow.ui.nodes.some(
    (node) =>
      node.attributes.name === "password" || node.attributes.type === "password"
  );
});

const isFormValid = computed(() => {
  if (!props.flow) return false;
  return props.flow.ui.nodes.every((node) => {
    if (isVisibleField(node) && node.attributes.required) {
      return !!props.formData[node.attributes.name];
    }
    return true;
  });
});

watch(
  () => props.flow,
  (newFlow) => {
    if (newFlow) {
      newFlow.ui.nodes.forEach((node) => {
        if (node.attributes.name && !props.formData[node.attributes.name]) {
          props.formData[node.attributes.name] = node.attributes.value || "";
        }
      });
      emit("update:formData", props.formData);
    }
  },
  { immediate: true, deep: true }
);

const handleSubmit = () => {
  const submissionData = { ...props.formData };
  props.flow.ui.nodes.forEach((node) => {
    if (isHiddenField(node)) {
      submissionData[node.attributes.name] = node.attributes.value;
    }
  });
  emit("submit", submissionData);
};
</script>

<style scoped>
.kratos-form {
  max-width: 400px;
  margin: 0 auto;
}

.form-group {
  margin-bottom: 1rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.form-input,
.form-select {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid var(--color-border, #ccc);
  border-radius: 4px;
  font-size: 1rem;
}

.input-error {
  border-color: var(--color-danger, #ff4d4f);
}

.error-message {
  display: block;
  color: var(--color-danger, #ff4d4f);
  font-size: 0.875rem;
  margin-top: 0.25rem;
}

.submit-button {
  width: 100%;
  padding: 0.75rem;
  background-color: var(--color-primary, #1890ff);
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
}

.submit-button:disabled {
  background-color: var(--color-disabled, #d9d9d9);
  cursor: not-allowed;
}

.button-icon {
  margin-right: 0.5rem;
}
</style>
