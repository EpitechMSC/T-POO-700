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
      } catch (err) {
        console.error('Erreur lors de la mise à jour du temps de travail', err);
      }
    };

    const confirmDeleteWorkingTime = (item: WorkingTime) => {
      if (confirm(`Êtes-vous sûr de vouloir supprimer ce temps de travail ?`)) {
        workingTimesStore.deleteWorkingTime(item.id);
      }
    };

    return {
      workingTimes,
      loading,
      error,
      editingItem,
      editWorkingTime,
      updateWorkingTime,
      confirmDeleteWorkingTime,
    };
  },
});
</script>

<style scoped></style>
