<template>
  <div class="p-6">
    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        :headers="['Nom', 'Email', 'Rôle']"
        :data="users"
        :current-page="pagingParams.pageNumber"
        :totalPages="totalPages"
        :items-per-page="pagingParams.pageSize"
        @edit-item="openUpdateModal"
        @delete-item="confirmDelete"
        @change-page="changePage"
      >
        <template #cell-Nom="{ item }">
          <div>{{ item.username }}</div>
        </template>
        <template #cell-Email="{ item }">
          <div>{{ item.email }}</div>
        </template>
        <template #cell-Rôle="{ item }">
          <div>{{ item.role }}</div>
        </template>
      </TableComponent>

      <ModalComponent v-model="showUpdateModal">
        <h2 class="text-lg font-semibold mb-4">Modifier l'utilisateur</h2>
        <label class="block mb-2">Nom:</label>
        <input
          type="text"
          v-model="updateForm.username"
          class="border border-gray-300 rounded p-2 w-full mb-4"
        />
        <label class="block mb-2">Email:</label>
        <input
          type="email"
          v-model="updateForm.email"
          class="border border-gray-300 rounded p-2 w-full mb-4"
        />
        <label class="block mb-2">Rôle:</label>
        <input
          type="text"
          v-model="updateForm.role"
          class="border border-gray-300 rounded p-2 w-full mb-4"
        />
        <div class="flex justify-end">
          <button
            class="px-4 py-2 bg-blue-500 text-white rounded"
            @click="updateUser"
          >
            Mettre à jour
          </button>
          <button
            class="ml-2 px-4 py-2 bg-gray-300 rounded"
            @click="closeUpdateModal"
          >
            Annuler
          </button>
        </div>
      </ModalComponent>

      <ModalComponent v-model="showDeleteConfirm">
        <h2 class="text-lg font-semibold mb-4">Confirmer la suppression</h2>
        <p>Êtes-vous sûr de vouloir supprimer cet utilisateur ?</p>
        <div class="flex justify-end mt-4">
          <button
            class="px-4 py-2 bg-red-500 text-white rounded"
            @click="deleteUser"
          >
            Supprimer
          </button>
          <button
            class="ml-2 px-4 py-2 bg-gray-300 rounded"
            @click="closeDeleteConfirm"
          >
            Annuler
          </button>
        </div>
      </ModalComponent>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, watch } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import ModalComponent from '../Modal/ModalComponent.vue';
import { useAuthenticateStore, useUsersStore } from '../../app/store/store';
import { User } from '../../app/models/user';

export default defineComponent({
  name: 'UsersList',
  components: { TableComponent, ModalComponent },
  setup() {
    const usersStore = useUsersStore();
    const authStore = useAuthenticateStore();

    const showUpdateModal = ref(false);
    const showDeleteConfirm = ref(false);
    const updateForm = ref({ username: '', email: '', role: 0 });
    const currentUserId = ref<number | null>(null);
    const userToDelete = ref<User | null>(null);

    const loadUsers = () => {
      usersStore.fetchAllUsers();
    };

    const users = computed(() => usersStore.users);
    const loading = computed(() => usersStore.loading);
    const error = computed(() => usersStore.error);
    const pagingParams = computed(() => usersStore.pagingParams);
    const totalPages = computed(() => usersStore.pagination?.total_pages || 0);

    const changePage = (newPage: number) => {
      if (newPage >= 1) {
        usersStore.setPage(newPage);
      }
    };

    const openUpdateModal = (user: User) => {
      updateForm.value = {
        username: user.username,
        email: user.email,
        role: user.role,
      };
      currentUserId.value = user.id;
      showUpdateModal.value = true;
    };

    const closeUpdateModal = () => {
      showUpdateModal.value = false;
      updateForm.value = { username: '', email: '', role: 0 };
      currentUserId.value = null;
    };

    const updateUser = async () => {
      if (currentUserId.value) {
        await usersStore.updateUser(
          currentUserId.value,
          updateForm.value as User
        );
        closeUpdateModal();
        loadUsers();
      }
    };

    const confirmDelete = (user: User) => {
      userToDelete.value = user;
      showDeleteConfirm.value = true;
    };

    const closeDeleteConfirm = () => {
      showDeleteConfirm.value = false;
      userToDelete.value = null;
    };

    const deleteUser = async () => {
      if (userToDelete.value) {
        await usersStore.deleteUser(userToDelete.value.id);
        closeDeleteConfirm();
        loadUsers();
      }
    };

    watch(() => authStore.user, loadUsers, { immediate: true });

    return {
      users,
      loading,
      error,
      changePage,
      pagingParams,
      totalPages,
      showUpdateModal,
      showDeleteConfirm,
      updateForm,
      openUpdateModal,
      confirmDelete,
      deleteUser,
      closeDeleteConfirm,
      closeUpdateModal,
      updateUser,
    };
  },
});
</script>

<style scoped></style>
