<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Liste des horloges</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent v-if="clocks.length > 0" :data="clocks" />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue';
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

    const deleteClock = (id: number) => {
      clocksStore.deleteClock(id);
    };

    return {
      clocks: clocksStore.clocks,
      loading: clocksStore.loading,
      error: clocksStore.error,
      deleteClock,
    };
  },
});
</script>

<style scoped></style>
