<template>
  <button
    :type="type"
    :class="buttonClasses"
    :disabled="disabled"
    @click="onClick"
  >
    <slot />
  </button>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue';
import { BaseButtonProps } from './BaseButton.types';

export default defineComponent({
  name: 'BaseButton',
  props: BaseButtonProps,
  setup(props) {
    const buttonClasses = computed(() => {
      const baseClasses =
        'font-medium rounded-lg text-sm px-5 py-2.5 text-center focus:outline-none focus:ring-4';

      const variantClasses = {
        primary:
          'text-white bg-gray-600 hover:bg-gray-700 focus:ring-gray-300 dark:bg-gray-600 dark:hover:bg-gray-700 dark:focus:ring-gray-800',
        secondary:
          'text-gray-700 bg-gray-200 hover:bg-gray-300 focus:ring-gray-400 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-500',
        danger:
          'text-white bg-red-600 hover:bg-red-700 focus:ring-red-300 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-800',
      };

      return [
        baseClasses,
        variantClasses[props.variant] || variantClasses.primary,
        props.fullWidth ? 'w-full' : '',
        props.disabled ? 'opacity-50 cursor-not-allowed' : '',
      ].join(' ');
    });

    const onClick = (event: Event) => {
      if (props.disabled) {
        event.preventDefault();
      }
    };

    return {
      buttonClasses,
      onClick,
    };
  },
});
</script>

<style scoped></style>
