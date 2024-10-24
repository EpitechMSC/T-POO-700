<template>
  <div class="mx-4 min-h-screen max-w-screen-xl sm:mx-8 xl:mx-auto">
    <h1 class="border-b py-6 text-4xl font-semibold">Documents</h1>
    <div class="grid grid-cols-8 pt-3 sm:grid-cols-10">
      <!-- Navigation Section -->
      <SettingsNavigationMenu />

      <!-- Content Section -->
      <div
        class="col-span-8 overflow-hidden rounded-xl sm:bg-gray-50 sm:px-8 sm:shadow"
      >
        <div class="pt-4">
          <h1 class="py-2 text-2xl font-semibold">
            Vos Documents à Télécharger
          </h1>
        </div>
        <hr class="mt-4 mb-8" />

        <div class="mt-8">
          <h2 class="py-2 text-xl font-semibold">Réglementations</h2>
          <ul>
            <li>
              <a
                :href="`/documents/reglementation-heures-de-travail.pdf`"
                target="_blank"
                class="text-blue-600 underline"
              >
                Réglementation des Heures de Travail
              </a>
            </li>
            <li>
              <a
                :href="`/documents/contrat_35h.pdf`"
                target="_blank"
                class="text-blue-600 underline"
              >
                Réglementation des Contrats
              </a>
            </li>
            <li>
              <a
                :href="`/documents/reglement.pdf`"
                target="_blank"
                class="text-blue-600 underline"
              >
                Réglementation des Poubelles Jaunes
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
import SettingsNavigationMenu from './SettingsNavigationMenu.vue';

export default defineComponent({
  name: 'SettingsDocuments',
  components: {
    SettingsNavigationMenu,
  },
  setup() {
    const authStore = useAuthenticateStore();

    return {
      user: authStore.getUser,
    };
  },
});
</script>

<style scoped></style>
