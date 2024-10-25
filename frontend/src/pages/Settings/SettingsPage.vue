<template>
  <div class="mx-4 min-h-screen max-w-screen-xl sm:mx-8 xl:mx-auto">
    <h1 class="border-b py-6 text-4xl font-semibold">Paramètres</h1>
    <div class="grid grid-cols-8 pt-3 sm:grid-cols-10">
      <!-- Navigation Section -->
      <SettingsNavigationMenu />

      <!-- Content Section -->
      <div
        class="col-span-8 overflow-hidden rounded-xl sm:bg-gray-50 sm:px-8 sm:shadow"
      >
        <div class="pt-4">
          <h1 class="py-2 text-2xl font-semibold">Paramètres du compte</h1>
        </div>
        <hr class="mt-4 mb-8" />

        <!-- Nom d'utilisateur -->
        <p class="py-2 text-xl font-semibold">Nom d'utilisateur</p>
        <div
          class="flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <p class="text-gray-600">
            Votre nom d'utilisateur est <strong>{{ user?.username }}</strong>
          </p>
          <button
            class="inline-flex text-sm font-semibold text-blue-600 underline decoration-2"
            @click="toggleUsernameEdit"
          >
            Modifier
          </button>
        </div>

        <!-- Edit Username -->
        <div
          v-if="isEditingUsername"
          class="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <div
            class="relative flex overflow-hidden rounded-md border-2 transition focus-within:border-blue-600"
          >
            <input
              v-model="username"
              type="text"
              class="w-full flex-shrink appearance-none border-gray-300 bg-white py-2 px-4 text-base text-gray-700 placeholder-gray-400 focus:outline-none"
              placeholder="Nouveau nom d'utilisateur"
            />
            />
          </div>
          <button
            class="mt-4 rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveUsername"
          >
            Enregistrer le nom d'utilisateur
          </button>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Email -->
        <p class="py-2 text-xl font-semibold">Adresse e-mail</p>
        <div
          class="flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <p class="text-gray-600">
            Votre adresse e-mail est <strong>{{ user?.email }}</strong>
          </p>
          <button
            class="inline-flex text-sm font-semibold text-blue-600 underline decoration-2"
            @click="toggleEmailEdit"
          >
            Modifier
          </button>
        </div>

        <!-- Edit Email -->
        <div
          v-if="isEditingEmail"
          class="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <div
            class="relative flex overflow-hidden rounded-md border-2 transition focus-within:border-blue-600"
          >
            <input
              v-model="email"
              type="email"
              class="w-full flex-shrink appearance-none border-gray-300 bg-white py-2 px-4 text-base text-gray-700 placeholder-gray-400 focus:outline-none"
              placeholder="Nouvelle adresse e-mail"
            />
          </div>
          <button
            class="mt-4 rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveEmail"
          >
            Enregistrer l'e-mail
          </button>
        </div>
        <!-- <UploadFileComponent/> -->
        <hr class="mt-4 mb-8" />
        <!-- Delete Account -->
        <div v-if="userRole === 'Supervisor'" class="mb-10">
          <p class="py-2 text-xl font-semibold">Supprimer le compte</p>
          <p
            class="inline-flex items-center rounded-full bg-rose-100 px-4 py-1 text-rose-600"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="mr-2 h-5 w-5"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path
                fill-rule="evenodd"
                d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd"
              />
            </svg>
            Proceed with caution
          </p>
          <p class="mt-2">
            Assurez-vous d'avoir fait une sauvegarde de votre compte. Il n'y a
            aucun moyen d'accéder à votre compte après cette action.
          </p>
          <button
            class="ml-auto text-sm font-semibold text-rose-600 underline decoration-2"
            @click="deleteAccount"
          >
            Continuer avec la suppression
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

    const toggleUsernameEdit = () => {
      isEditingUsername.value = !isEditingUsername.value;
    };

    const toggleEmailEdit = () => {
      isEditingEmail.value = !isEditingEmail.value;
    };

    const saveUsername = async () => {
      if (user.value) {
        await usersStore.updateUser(user.value.id, {
          ...user.value,
          username: username.value,
        });
        user.value.username = username.value;
        toggleUsernameEdit();
      }
    };

    const saveEmail = async () => {
      if (user.value) {
        await usersStore.updateUser(user.value.id, {
          ...user.value,
          email: email.value,
        });
        user.value.email = email.value;
        toggleEmailEdit();
      }
    };

    const deleteAccount = async () => {
      if (user.value) {
        await usersStore.deleteUser(user.value.id);
        authStore.logout();
      }
    };

    onMounted(async () => {
      if (!user.value) {
        await authStore.fetchUser();
        user.value = authStore.getUser;
      }
    });

    return {
      user,
      username,
      userRole,
      email,
      isEditingUsername,
      isEditingEmail,
      toggleUsernameEdit,
      saveUsername,
      toggleEmailEdit,
      saveEmail,
      deleteAccount,
    };
  },
});
</script>

<style scoped></style>
