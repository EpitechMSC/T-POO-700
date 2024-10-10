<template>
  <div class="p-6 h-64">
    <h1 class="text-2xl font-bold mb-4">Liste des horloges</h1>

    <div v-if="loading" class="text-gray-500">Chargement...</div>
    <div v-if="error" class="text-red-600">{{ error }}</div>

    <div v-if="!loading && !error">
      <TableComponent
        v-if="clocks.length > 0"
        :data="clocks"
        @edit-item="editClock"
        @delete-item="confirmDeleteClock"
        @save-edit="updateClock"
      />
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
import { defineComponent, onMounted, computed, ref } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useClocksStore } from '../../app/store/store';
import { Clock } from '../../app/models/clock';

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
    const editingItem = ref<Clock | null>(null);

    const editClock = (item: Clock) => {
      editingItem.value = { ...item };
      console.log("Modifier l'élément :", editingItem.value);
    };

    const updateClock = async (updatedItem: Clock) => {
      const { id, ...modifiableData } = updatedItem;

      console.log(modifiableData);
      try {
        await clocksStore.updateClock(id, modifiableData as Clock);
        editingItem.value = null;
      } catch (err) {
        console.error("Erreur lors de la mise à jour de l'horloge", err);
      }
    };

    const confirmDeleteClock = (item: Clock) => {
      if (confirm(`Êtes-vous sûr de vouloir supprimer cette horloge ?`)) {
        clocksStore.deleteClock(item.id);
      }
    };

    return {
      clocks,
      loading,
      error,
      editingItem,
      editClock,
      updateClock,
      confirmDeleteClock,
    };
  },
});
</script>

<style scoped></style>
