<template>
  <div class="col-span-2 hidden sm:block">
    <ul>
      <!-- Lien vers la page des paramètres -->
      <li
        class="mt-5 cursor-pointer border-l-2 border-transparent px-2 py-2 font-semibold transition hover:border-l-blue-700 hover:text-blue-700"
        :class="{ 'border-l-blue-700 text-blue-700': isActive('settings') }"
      >
        <router-link :to="`/users/${user?.id}/settings`"> Account </router-link>
      </li>

      <!-- Lien pour la page des équipes -->
      <li
        class="mt-5 cursor-pointer border-l-2 border-transparent px-2 py-2 font-semibold transition hover:border-l-blue-700 hover:text-blue-700"
      >
        <router-link :to="`/users/employees`"> Employees </router-link>
      </li>

      <!-- Lien vers la page des documents -->
      <li
        class="mt-5 cursor-pointer border-l-2 border-transparent px-2 py-2 font-semibold transition hover:border-l-blue-700 hover:text-blue-700"
        :class="{ 'border-l-blue-700 text-blue-700': isActive('documents') }"
      >
        <router-link :to="`/users/${user?.id}/documents`">
          Documents
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';

export default defineComponent({
  name: 'SettingsNavigationMenu',
  setup() {
    const authStore = useAuthenticateStore();
    const user = authStore.getUser;

    const isActive = (page: string) => {
      const currentPath = window.location.pathname;
      if (!user) return false;
      return (
        (page === 'documents' &&
          currentPath.includes(`/users/${user.id}/documents`)) ||
        (page === 'settings' &&
          currentPath.includes(`/users/${user.id}/settings`))
      );
    };

    return {
      user,
      isActive,
    };
  },
});
</script>

<style scoped></style>
