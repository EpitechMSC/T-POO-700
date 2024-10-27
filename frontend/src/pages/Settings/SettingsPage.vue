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
            @click="toggleEdit('username')"
          >
            Modifier
          </button>
        </div>

        <!-- Edit Username -->
        <div
          v-if="isEditingUsername"
          class="mt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between"
        >
          <input
            v-model="username"
            type="text"
            class="w-full rounded-md border py-2 px-4 text-base focus:border-blue-600"
            placeholder="Nouveau nom d'utilisateur"
          />
          <button
            class="mt-4 rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveChanges('username')"
          >
            Enregistrer
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
            @click="toggleEdit('email')"
          >
            Modifier
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
            placeholder="Nouvelle adresse e-mail"
          />
          <button
            class="mt-4 rounded-lg bg-blue-600 px-4 py-2 text-white"
            @click="saveChanges('email')"
          >
            Enregistrer
          </button>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Contrat -->
        <div class="mb-10">
          <p class="py-2 text-xl font-semibold">Votre contrat</p>
          <p class="text-gray-600">
            Vous avez un contrat de
            <strong>{{
              contractDetails ? contractDetails.temps : 'Contrat non défini'
            }}</strong>
            heures par semaine.
          </p>
        </div>

        <hr class="mt-4 mb-8" />

        <!-- Supprimer le compte -->
        <div v-if="userRole === 'Supervisor'" class="mb-10">
          <p class="py-2 text-xl font-semibold">Supprimer le compte</p>
          <p class="mt-2">
            Assurez-vous d'avoir sauvegardé votre compte. Cette action est
            irréversible.
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
    const contractDetails = ref(null);

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

    // Fetch contract details based on user's contract ID
    onMounted(async () => {
      if (!user.value) {
        await authStore.fetchUser();
        user.value = authStore.getUser;
      }

      if (user.value?.contrat) {
        if (user.value.contrat == 1) {
          contractDetails.value = {
            temps: 35,
          };
        } else if (user.value.contrat == 2) {
          contractDetails.value = {
            temps: 39,
          };
        } else if (user.value.contrat == 3) {
          contractDetails.value = {
            temps: 42,
          };
        } else {
          contractDetails.value = null;
        }
      }
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
      contractDetails,
    };
  },
});
</script>
