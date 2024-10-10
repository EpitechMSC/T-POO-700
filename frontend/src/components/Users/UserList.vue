<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Liste des utilisateurs</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        v-if="users.length > 0"
        :data="users"
        @edit-item="editUser"
        @delete-item="confirmDeleteUser"
        @save-edit="updateUser"
      />
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
import { defineComponent, onMounted, computed, ref } from 'vue';
import { useUsersStore } from '../../app/store/store';
import TableComponent from '../Table/TableComponent.vue';
import { User } from '../../app/models/user';

export default defineComponent({
  name: 'UserList',
  components: {
    TableComponent,
  },
  setup() {
    const usersStore = useUsersStore();
    const editingItem = ref<User | null>(null);

    onMounted(() => {
      usersStore.fetchAllUsers();
    });

    const users = computed(() => usersStore.users);
    const loading = computed(() => usersStore.loading);
    const error = computed(() => usersStore.error);

    const editUser = (item: User) => {
      editingItem.value = { ...item };
      console.log("Modifier l'élément :", editingItem.value);
    };

    const updateUser = async (updatedItem: User) => {
      const { id, ...modifiableData } = updatedItem;

      console.log(modifiableData);
      try {
        await usersStore.updateUser(id, modifiableData as User);
        editingItem.value = null;
      } catch (err) {
        console.error("Erreur lors de la mise à jour de l'utilisateur", err);
      }
    };

    const confirmDeleteUser = (item: User) => {
      if (confirm(`Êtes-vous sûr de vouloir supprimer cet utilisateur ?`)) {
        usersStore.deleteUser(item.id);
      }
    };

    return {
      users,
      loading,
      error,
      editingItem,
      editUser,
      updateUser,
      confirmDeleteUser,
    };
  },
});
</script>

<style scoped></style>
