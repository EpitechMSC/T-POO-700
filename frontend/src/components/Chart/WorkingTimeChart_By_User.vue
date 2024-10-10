<template>
  <div class="p-6 text-center w-2/3 h-full">
    <h2 class="text-2xl mb-6" style="font-family: 'Inter', sans-serif">
      Évolution du temps de travail
    </h2>

    <select v-model="selectedUser" class="mb-4 p-2 border rounded">
      <option v-for="user in users" :key="user.id" :value="user.id">
        {{ user.name }}
      </option>
    </select>

    <LineChart
      v-if="chartData"
      :data="chartData"
      :options="chartOptions"
      class="h-full"
    />
    <p v-if="loading">Chargement...</p>
    <p v-if="error">{{ error }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue';
import { Line } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  Filler,
  CategoryScale,
  LinearScale,
} from 'chart.js';
import { useWorkingTimesStore } from '../../app/store/store';

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  Filler,
  CategoryScale,
  LinearScale
);

export default defineComponent({
  name: 'WorkingTimeChart',
  components: {
    LineChart: Line,
  },
  setup() {
    const store = useWorkingTimesStore();
    const loading = ref(false);
    const error = ref<string | null>(null);
    const selectedUser = ref(null);

    // Récupérer les utilisateurs
    const users = computed(() => store.users);

    const fetchData = async () => {
      loading.value = true;
      error.value = null;
      try {
        await store.fetchUsers(); // Charger d'abord les utilisateurs
        if (users.value.length > 0) {
          selectedUser.value = users.value[0].id; // Initialiser l'utilisateur sélectionné
          await store.fetchWorkingTimes(selectedUser.value); // Ensuite, charger les temps de travail
        }
      } catch (err) {
        error.value = 'Erreur lors de la récupération des données.';
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchData);

    const chartData = computed(() => {
      if (!selectedUser.value) return null; // Retourne null si aucun utilisateur n'est sélectionné

      const filteredWorkingTimes = store.workingTimes.filter(
        wt => wt.userId === selectedUser.value
      );

      const labels = filteredWorkingTimes
        .map(wt => {
          const startDate = new Date(wt.start);
          return startDate.toLocaleDateString();
        })
        .reverse();

      const data = filteredWorkingTimes
        .map(wt => {
          const start = new Date(wt.start);
          const end = new Date(wt.end);
          const duration = (end.getTime() - start.getTime()) / 3600000;
          return duration;
        })
        .reverse();

      return {
        labels,
        datasets: [
          {
            label: 'Heures de travail',
            backgroundColor: 'rgba(66, 165, 245, 0.5)',
            borderColor: '#42A5F5',
            borderWidth: 2,
            fill: true,
            data,
          },
        ],
      };
    });

    const chartOptions = {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
        },
      },
    };

    return {
      loading,
      error,
      chartData,
      chartOptions,
      selectedUser,
      users,
    };
  },
});
</script>

<style scoped></style>
