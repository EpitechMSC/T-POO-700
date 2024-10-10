<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Liste des temps de travail</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent v-if="workingTimes.length > 0" :data="workingTimes" />
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
import { defineComponent, onMounted, computed } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useWorkingTimesStore } from '../../app/store/store';

export default defineComponent({
  name: 'WorkingTimeList',
  components: {
    TableComponent,
  },
  setup() {
    const workingTimesStore = useWorkingTimesStore();

    onMounted(() => {
      workingTimesStore.fetchWorkingTimes();
    });

    const workingTimes = computed(() => workingTimesStore.workingTimes);
    const loading = computed(() => workingTimesStore.loading);
    const error = computed(() => workingTimesStore.error);

    return {
      workingTimes,
      loading,
      error,
    };
  },
});
</script>

<style scoped></style>
