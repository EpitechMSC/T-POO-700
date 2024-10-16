<template>
  <div class="p-6">
    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        :headers="['Jour', 'Début', 'Fin']"
        :readonly-headers="['Jour']"
        :data="workingTimes"
        @delete-item="deleteWorkingTime"
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
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useWorkingTimesStore } from '../../app/store/store';
import { useAuthenticateStore } from '../../app/store/store';

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
      }
    });

    const workingTimes = computed(() => workingTimesStore.workingTimesForList);
    const loading = computed(() => workingTimesStore.loading);
    const error = computed(() => workingTimesStore.error);

    const formatDay = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR'); // "dd/MM/yyyy"
    };

    const formatTime = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit',
      });
    };

    const deleteWorkingTime = async (item: any) => {
      await workingTimesStore.deleteWorkingTime(item.id);
      console.log('Suppression du temps de travail :', item);
    };

    return {
      workingTimes,
      loading,
      error,
      formatDay,
      formatTime,
      deleteWorkingTime,
    };
  },
});
</script>
