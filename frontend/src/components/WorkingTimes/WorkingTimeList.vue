<template>
  <div class="p-6">
    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        v-if="workingTimes.length > 0"
        :data="workingTimes"
        @edit-item="editWorkingTime"
        @delete-item="confirmDeleteWorkingTime"
        @save-edit="updateWorkingTime"
      />
      <div
        v-else
        class="text-center text-gray-500 border border-gray-300 rounded p-4"
      >
        <p class="text-lg">Aucun temps de travail trouvé.</p>
      </div>

      <!-- Contrôles de Pagination -->
      <div v-if="pagination">
        <nav class="flex">
          <div>
            <a
              href="#"
              @click.prevent="goToPage(pagination.current_page - 1)"
              class="flex items-center justify-center px-4 h-10 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              :disabled="pagination.current_page === 1"
            >
              <span class="sr-only">Previous</span>
              <svg
                class="w-3 h-3 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 6 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M5 1 1 5l4 4"
                />
              </svg>
            </a>
          </div>
          <ul
            class="flex items-center -space-x-px h-10 text-base overflow-x-auto scrollbar-hide"
          >
            <li v-for="page in totalPageNumbers" :key="page">
              <a
                href="#"
                @click.prevent="goToPage(page)"
                :class="[
                  'flex items-center justify-center px-4 h-10 leading-tight',
                  page === pagination.current_page
                    ? 'z-10 text-blue-600 border border-blue-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white'
                    : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white',
                ]"
              >
                {{ page }}
              </a>
            </li>
          </ul>
          <div>
            <a
              href="#"
              @click.prevent="goToPage(pagination.current_page + 1)"
              class="flex items-center justify-center px-4 h-10 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
              :disabled="pagination.current_page === pagination.total_pages"
            >
              <span class="sr-only">Next</span>
              <svg
                class="w-3 h-3 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 6 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 9 4-4-4-4"
                />
              </svg>
            </a>
          </div>
        </nav>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed, ref } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useWorkingTimesStore } from '../../app/store/store';
import { useAuthenticateStore } from '../../app/store/store';
import { WorkingTime } from '../../app/models/workingTime';

export default defineComponent({
  name: 'WorkingTimeList',
  components: {
    TableComponent,
  },
  setup() {
    const workingTimesStore = useWorkingTimesStore();
    const authStore = useAuthenticateStore();

    onMounted(() => {
      const userId = authStore.user?.id;
      if (userId) {
        workingTimesStore.fetchWorkingTimesByUserId(
          userId,
          workingTimesStore.pagingParams.pageNumber,
          workingTimesStore.pagingParams.pageSize
        );
      } else {
        workingTimesStore.error = 'Utilisateur non authentifié';
      }
    });

    const workingTimes = computed(() => workingTimesStore.workingTimesForList);
    const loading = computed(() => workingTimesStore.loading);
    const error = computed(() => workingTimesStore.error);
    const pagination = computed(() => workingTimesStore.pagination);

    console.log(pagination);

    const editingItem = ref<WorkingTime | null>(null);

    const editWorkingTime = (item: WorkingTime) => {
      editingItem.value = { ...item };
      console.log("Modifier l'élément :", editingItem.value);
    };

    const updateWorkingTime = async (updatedItem: WorkingTime) => {
      const { id, ...modifiableData } = updatedItem;

      try {
        await workingTimesStore.updateWorkingTime(
          id,
          modifiableData as WorkingTime
        );
        editingItem.value = null;
        const userId = authStore.user?.id;
        if (userId) {
          workingTimesStore.fetchWorkingTimesByUserId(
            userId,
            workingTimesStore.pagingParams.pageNumber,
            workingTimesStore.pagingParams.pageSize
          );
        }
      } catch (err) {
        console.error('Erreur lors de la mise à jour du temps de travail', err);
      }
    };

    const confirmDeleteWorkingTime = (item: WorkingTime) => {
      if (confirm(`Êtes-vous sûr de vouloir supprimer ce temps de travail ?`)) {
        workingTimesStore.deleteWorkingTime(item.id);
        // Optionnel: Rafraîchir la liste après suppression
        const userId = authStore.user?.id;
        if (userId) {
          workingTimesStore.fetchWorkingTimesByUserId(
            userId,
            workingTimesStore.pagingParams.pageNumber,
            workingTimesStore.pagingParams.pageSize
          );
        }
      }
    };

    const goToPage = (page: number) => {
      const userId = authStore.user?.id;
      if (userId) {
        workingTimesStore.setPage(page);
        workingTimesStore.fetchWorkingTimesByUserId(
          userId,
          page,
          workingTimesStore.pagingParams.pageSize
        );
      }
    };

    const totalPageNumbers = computed(() => {
      if (!pagination.value) return [];
      const pages = [];
      for (let i = 1; i <= pagination.value.total_pages; i++) {
        pages.push(i);
      }
      return pages;
    });

    return {
      workingTimes,
      loading,
      error,
      editingItem,
      editWorkingTime,
      updateWorkingTime,
      confirmDeleteWorkingTime,
      pagination,
      goToPage,
      totalPageNumbers,
    };
  },
});
</script>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

/* For IE, Edge and Firefox */
.scrollbar-hide {
  -ms-overflow-style: none; /* IE and Edge */
  scrollbar-width: none; /* Firefox */
}
</style>
