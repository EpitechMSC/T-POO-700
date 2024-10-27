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

        <div class="mx-4 mb-8">
          <ul>
            <li
              v-for="(doc, index) in documents"
              :key="index"
              class="flex gap-2 my-1"
            >
              <a
                v-if="doc.show"
                :href="baseUrl + doc.path"
                target="_blank"
                class="text-blue-600 underline"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"
                  />
                </svg>
              </a>
              {{ doc.label }}
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
import SettingsNavigationMenu from './SettingsNavigationMenu.vue';

export default defineComponent({
  name: 'SettingsDocuments',
  components: {
    SettingsNavigationMenu,
  },
  setup() {
    const authStore = useAuthenticateStore();
    const user = ref(authStore.getUser);
    const baseUrl = window.location.origin;
    const contractDetails = ref(null);

    onMounted(async () => {
      if (!user.value) {
        await authStore.fetchUser();
        user.value = authStore.getUser;
      }
      if (user.value?.contrat) {
        const contractMapping = {
          1: { temps: 35 },
          2: { temps: 39 },
          3: { temps: 42 },
        };
        contractDetails.value = contractMapping[user.value.contrat] || null;
      }
    });

    const documents = computed(() => [
      {
        label: 'Réglementation des Heures de Travail',
        path: '/api/documents/reglementation-heures-de-travail.pdf',
        show: true,
      },
      {
        label: 'Télécharger votre contrat',
        path: contractDetails.value
          ? `/api/documents/contrat_${contractDetails.value.temps}h.pdf`
          : '',
        show: contractDetails.value !== null,
      },
      {
        label: 'Réglement Intérieur',
        path: '/api/documents/reglement.pdf',
        show: true,
      },
      {
        label: 'FAQ',
        path: '/api/documents/FAQ.pdf',
        show: true,
      },
    ]);

    return {
      baseUrl,
      documents,
    };
  },
});
</script>

<style scoped></style>
