<template>
  <div class="p-6">
    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        :headers="['Jour', 'Début', 'Fin']"
        :data="workingTimes"
        :current-page="pagingParams.pageNumber"
        :totalPages="totalPages"
        :items-per-page="pagingParams.pageSize"
        @edit-item="openUpdateModal"
        @delete-item="confirmDelete"
        @change-page="changePage"
      >
        <template #cell-Jour="{ item }">
          <div>{{ formatDay(item.start) }}</div>
        </template>

        <template #cell-Début="{ item }">
          <div>{{ formatTime(item.start) }}</div>
        </template>

        <template #cell-Fin="{ item }">
          <div>{{ formatTime(item.end) }}</div>
        </template>
      </TableComponent>

      <div
        v-if="showUpdateModal"
        class="fixed inset-0 flex items-center justify-center z-50"
      >
        <div class="bg-white p-6 rounded shadow-md">
          <h2 class="text-lg font-semibold mb-4">
            Modifier le temps de travail
          </h2>
          <label class="block mb-2">Début:</label>
          <input
            type="datetime-local"
            v-model="updateForm.start"
            class="border border-gray-300 rounded p-2 w-full mb-4"
          />
          <label class="block mb-2">Fin:</label>
          <input
            type="datetime-local"
            v-model="updateForm.end"
            class="border border-gray-300 rounded p-2 w-full mb-4"
          />
          <div class="flex justify-end">
            <button
              class="px-4 py-2 bg-blue-500 text-white rounded"
              @click="updateWorkingTime"
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
        </div>
      </div>

      <div
        v-if="showDeleteConfirm"
        class="fixed inset-0 flex items-center justify-center z-50"
      >
        <div class="bg-white p-6 rounded shadow-md">
          <h2 class="text-lg font-semibold mb-4">Confirmer la suppression</h2>
          <p>Êtes-vous sûr de vouloir supprimer ce temps de travail ?</p>
          <div class="flex justify-end mt-4">
            <button
              class="px-4 py-2 bg-red-500 text-white rounded"
              @click="deleteWorkingTime"
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
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed, ref, watch } from 'vue';
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
    const showUpdateModal = ref(false);
    const showDeleteConfirm = ref(false);
    const updateForm = ref<{ start: string; end: string }>({
      start: '',
      end: '',
    });
    const currentWorkingTimeId = ref<number | null>(null);
    const itemToDelete = ref<WorkingTime | null>(null);

    const loadWorkingTimes = () => {
      const userId = authStore.user?.id;
      if (userId) {
        workingTimesStore.fetchWorkingTimesByUserId(
          userId,
          workingTimesStore.pagingParams.pageNumber,
          workingTimesStore.pagingParams.pageSize
        );
      }
    };

    watch(
      () => authStore.user,
      newUser => {
        if (newUser?.id) {
          loadWorkingTimes();
        }
      },
      { immediate: true }
    );

    watch(
      () => workingTimesStore.pagingParams.pageNumber,
      newPageNumber => {
        const userId = authStore.user?.id;
        if (userId) {
          loadWorkingTimes();
        }
      }
    );

    const workingTimes = computed(() => workingTimesStore.workingTimesForList);
    const loading = computed(() => workingTimesStore.loading);
    const error = computed(() => workingTimesStore.error);
    const pagingParams = computed(() => workingTimesStore.pagingParams);
    const totalPages = computed(
      () => workingTimesStore.pagination?.total_pages || 0
    );

    const changePage = async (newPage: number) => {
      const userId = authStore.user?.id;
      if (newPage >= 1 && userId) {
        await workingTimesStore.setPage(
          workingTimesStore.fetchWorkingTimesByUserId,
          userId,
          newPage
        );
      }
    };

    const formatDay = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR');
    };

    const formatTime = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit',
      });
    };

    const confirmDelete = (item: WorkingTime) => {
      itemToDelete.value = item;
      showDeleteConfirm.value = true;
    };

    const closeDeleteConfirm = () => {
      showDeleteConfirm.value = false;
      itemToDelete.value = null;
    };

    const deleteWorkingTime = async () => {
      if (itemToDelete.value) {
        await workingTimesStore.deleteWorkingTime(itemToDelete.value.id);
        closeDeleteConfirm();
        loadWorkingTimes();
      }
    };

    const openUpdateModal = (item: WorkingTime) => {
      updateForm.value.start = item.start;
      updateForm.value.end = item.end;
      currentWorkingTimeId.value = item.id;
      showUpdateModal.value = true;
    };

    const closeUpdateModal = () => {
      showUpdateModal.value = false;
      updateForm.value = { start: '', end: '' };
      currentWorkingTimeId.value = null;
    };

    const updateWorkingTime = async () => {
      if (currentWorkingTimeId.value) {
        const updatedTime = {
          start: updateForm.value.start,
          end: updateForm.value.end,
        };
        await workingTimesStore.updateWorkingTime(
          currentWorkingTimeId.value,
          updatedTime
        );
        closeUpdateModal();
        loadWorkingTimes();
      }
    };

    return {
      workingTimes,
      loading,
      error,
      changePage,
      pagingParams,
      totalPages,
      showUpdateModal,
      showDeleteConfirm,
      updateForm,
      currentWorkingTimeId,
      itemToDelete,
      loadWorkingTimes,
      openUpdateModal,
      confirmDelete,
      deleteWorkingTime,
      closeDeleteConfirm,
      closeUpdateModal,
      updateWorkingTime,
      formatDay,
      formatTime,
    };
  },
});
</script>
