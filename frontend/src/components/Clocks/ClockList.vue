<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Liste des horloges</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent v-if="clocks.length > 0" :data="clocks" />
      <div
        v-else
        class="text-center text-gray-500 border border-gray-300 rounded p-4"
      >
        <p class="text-lg">Aucune horloge trouvée.</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, computed } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useClocksStore } from '../../app/store/modules/clocks';

export default defineComponent({
  name: 'ClockList',
  components: {
    TableComponent,
  },
  setup() {
    const clocksStore = useClocksStore();

    onMounted(() => {
      clocksStore.fetchClocks();
    });

    const clocks = computed(() => clocksStore.clocks);
    const loading = computed(() => clocksStore.loading);
    const error = computed(() => clocksStore.error);
    const deleteClock = (id: number) => {
      clocksStore.deleteClock(id);
    };

    return {
      clocks,
      loading,
      error,
      deleteClock,
    };
  },
});
</script>

<style scoped></style>
