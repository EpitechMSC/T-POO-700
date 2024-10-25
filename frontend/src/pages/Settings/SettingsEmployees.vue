<template>
  <div class="mx-4 min-h-screen max-w-screen-xl sm:mx-8 xl:mx-auto">
    <h1 class="border-b py-6 text-4xl font-semibold">Employees</h1>
    <div class="grid grid-cols-8 pt-3 sm:grid-cols-10">
      <!-- Navigation Section -->
      <SettingsNavigationMenu />

      <!-- Content Section -->
      <div>Employees section</div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import SettingsNavigationMenu from './SettingsNavigationMenu.vue';

export default defineComponent({
  name: 'SettingsDocuments',
  components: {
    SettingsNavigationMenu,
  },
  setup() {
    return {};
  },
});
</script>

<style scoped></style>
