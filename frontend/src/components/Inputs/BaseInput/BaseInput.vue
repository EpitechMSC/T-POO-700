<!-- src/components/BaseInput/BaseInput.vue -->
<template>
  <div class="input-wrapper">
    <label
      :for="id"
      class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
      v-if="label"
    >
      {{ label }}
    </label>
    <input
      :type="type"
      :id="id"
      :name="name"
      :placeholder="placeholder"
      v-model="internalValue"
      :class="[
        'bg-gray-50 border border-gray-300 text-gray-900 rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5',
        darkModeClasses,
        error ? 'border-red-500 focus:border-red-500' : '',
      ]"
      :required="required"
    />
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue';
import { BaseInputProps } from './BaseInput.type';

export default defineComponent({
  name: 'BaseInput',
  props: BaseInputProps,
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const darkModeClasses = computed(() =>
      props.darkMode
        ? 'dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
        : ''
    );

    const internalValue = computed({
      get() {
        return props.modelValue;
      },
      set(value: string) {
        emit('update:modelValue', value);
      },
    });

    return {
      darkModeClasses,
      internalValue,
    };
  },
});
</script>

<style scoped>
.input-wrapper {
  margin-bottom: 1rem;
}
</style>
