<template>
  <div
    v-if="isOpen"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    @click="handleBackgroundClick"
  >
    <div class="bg-white p-6 rounded-lg shadow-lg max-w-md w-full" @click.stop>
      <slot></slot>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'ModalComponent',
  props: {
    modelValue: {
      type: Boolean,
      required: true,
    },
  },
  emits: ['update:modelValue'],
  computed: {
    isOpen() {
      return this.modelValue;
    },
  },
  methods: {
    handleBackgroundClick() {
      this.$emit('update:modelValue', false);
    },
  },
});
</script>

<style scoped></style>
