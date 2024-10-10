<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Liste des utilisateurs</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent v-if="users.length > 0" :data="users" />
      <div
        v-else
        class="text-center text-gray-500 border border-gray-300 rounded p-4"
      >
        <p class="text-lg">Aucun utilisateur trouvé.</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue';
import { useUsersStore } from '../../app/store/store';
import TableComponent from '../Table/TableComponent.vue';

export default defineComponent({
  name: 'UserList',
  components: {
    TableComponent,
  },
  setup() {
    const usersStore = useUsersStore();

    onMounted(() => {
      usersStore.fetchAllUsers();
    });

    const users = computed(() => usersStore.users);
    const loading = computed(() => usersStore.loading);
    const error = computed(() => usersStore.error);

    const deleteUser = (id: number) => {
      usersStore.deleteUser(id);
    };

    return {
      users,
      loading,
      error,
      deleteUser,
    };
  },
});
</script>

<style scoped></style>
