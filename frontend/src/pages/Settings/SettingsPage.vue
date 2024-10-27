<template>
  <div class="mx-4 min-h-screen max-w-screen-xl sm:mx-8 xl:mx-auto">
    <h1 class="border-b py-6 text-4xl font-semibold">Account</h1>
    <div class="grid grid-cols-8 pt-3 sm:grid-cols-10">
      <!-- Navigation Section -->
      <SettingsNavigationMenu />

      <!-- Content Section -->
      <div
        class="col-span-8 overflow-hidden rounded-xl sm:bg-gray-50 sm:px-8 sm:shadow"
      >
        <div class="pt-4">
          <h1 class="flex items-center gap-4 py-2 text-2xl font-semibold">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="size-6"
            >
              <path
                fill-rule="evenodd"
                d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z"
                clip-rule="evenodd"
              />
            </svg>
            Account Settings
          </h1>
        </div>
        <hr class="mt-4 mb-8" />

        <p class="py-2 text-xl font-semibold">Username</p>
        <div
          class="flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <p class="text-gray-600">
            Your username is <strong>{{ user?.username }}</strong>
          </p>
          <button
            class="inline-flex text-sm font-semibold text-blue-600 underline decoration-2"
            @click="toggleEdit('username')"
          >
            Edit
          </button>
        </div>

        <div
          v-if="isEditingUsername"
          class="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <input
            v-model="username"
            type="text"
            class="w-full rounded-md border py-2 px-4 text-base focus:border-blue-600"
            placeholder="New username"
          />
          <button
            class="flex rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveChanges('username')"
          >
            Save
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="size-6"
            >
              <path
                fill-rule="evenodd"
                d="M19.916 4.626a.75.75 0 0 1 .208 1.04l-9 13.5a.75.75 0 0 1-1.154.114l-6-6a.75.75 0 0 1 1.06-1.06l5.353 5.353 8.493-12.74a.75.75 0 0 1 1.04-.207Z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Email -->
        <p class="py-2 text-xl font-semibold">Email address</p>
        <div
          class="flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <p class="text-gray-600">
            Your email address is <strong>{{ user?.email }}</strong>
          </p>
          <button
            class="inline-flex text-sm font-semibold text-blue-600 underline decoration-2"
            @click="toggleEdit('email')"
          >
            Edit
          </button>
        </div>

        <!-- Edit Email -->
        <div
          v-if="isEditingEmail"
          class="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <input
            v-model="email"
            type="email"
            class="w-full rounded-md border py-2 px-4 text-base focus:border-blue-600"
            placeholder="New email address"
          />
          <button
            class="flex rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveChanges('username')"
          >
            Save
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="size-6"
            >
              <path
                fill-rule="evenodd"
                d="M19.916 4.626a.75.75 0 0 1 .208 1.04l-9 13.5a.75.75 0 0 1-1.154.114l-6-6a.75.75 0 0 1 1.06-1.06l5.353 5.353 8.493-12.74a.75.75 0 0 1 1.04-.207Z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Contrat -->
        <div class="mb-10">
          <p class="py-2 text-xl font-semibold">Your contract</p>
          <p class="text-gray-600">
            You have a contract of
            <strong>{{ contratDetails ?? '420' }}</strong>
            hours per week.
          </p>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Supprimer le compte -->
        <div v-if="userRole === 'Supervisor'" class="mb-10">
          <p class="py-2 text-xl font-semibold">Delete account</p>
          <p class="mt-2">
            Make sure you have backed up your account.<br />This action is
            irreversible.
          </p>
          <button
            class="flex gap-1 ml-auto text-sm font-semibold text-rose-600 underline decoration-2"
            @click="deleteAccount"
          >
            Proceed with deletion
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="size-6"
            >
              <path
                fill-rule="evenodd"
                d="m6.72 5.66 11.62 11.62A8.25 8.25 0 0 0 6.72 5.66Zm10.56 12.68L5.66 6.72a8.25 8.25 0 0 0 11.62 11.62ZM5.105 5.106c3.807-3.808 9.98-3.808 13.788 0 3.808 3.807 3.808 9.98 0 13.788-3.807 3.808-9.98 3.808-13.788 0-3.808-3.807-3.808-9.98 0-13.788Z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useAuthenticateStore, useUsersStore } from '../../app/store/store';
import SettingsNavigationMenu from './SettingsNavigationMenu.vue';

export default defineComponent({
  name: 'SettingsPage',
  components: {
    SettingsNavigationMenu,
  },
  setup() {
    const authStore = useAuthenticateStore();
    const usersStore = useUsersStore();

    const user = ref(authStore.getUser);
    const userRole = ref(authStore.getUserRole);
    const username = ref(user.value?.username || '');
    const email = ref(user.value?.email || '');
    const isEditingUsername = ref(false);
    const isEditingEmail = ref(false);
    const contratDetails = ref<number | null>(null);

    const toggleEdit = (field: string) => {
      if (field === 'username')
        isEditingUsername.value = !isEditingUsername.value;
      if (field === 'email') isEditingEmail.value = !isEditingEmail.value;
    };

    const saveChanges = async (field: string) => {
      if (user.value) {
        const updatedData =
          field === 'username'
            ? { username: username.value }
            : { email: email.value };
        await usersStore.updateUser(user.value.id, {
          ...user.value,
          ...updatedData,
        });

        // Update user locally
        if (field === 'username') user.value.username = username.value;
        if (field === 'email') user.value.email = email.value;
        toggleEdit(field);
      }
    };

    const deleteAccount = async () => {
      if (user.value) {
        await usersStore.deleteUser(user.value.id);
        authStore.logout();
      }
    };

    // Fetch contrat details based on user's contrat ID
    onMounted(async () => {
      if (!user.value) {
        await authStore.fetchUser();
        user.value = authStore.getUser;
      }
      contratDetails.value = user.value?.contrat.temps ?? null;
    });

    return {
      user,
      userRole,
      username,
      email,
      isEditingUsername,
      isEditingEmail,
      toggleEdit,
      saveChanges,
      deleteAccount,
      contratDetails,
    };
  },
});
</script>
