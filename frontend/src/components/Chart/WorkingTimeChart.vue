<template>
  <div class="w-full">
    <div class="flex justify-between mb-4">
      <select
        v-model="selectedPeriod"
        @change="fetchData"
      >
        <option value="yearly">
          Année
        </option>
        <option value="weekly">
          Hebdomadaire
        </option>
        <option value="monthly">
          Mensuel
        </option>
      </select>
    </div>
    <LineChart
      v-if="!loading && chartData"
      :data="chartData"
      :options="chartOptions"
      class="w-full"
    />
    <p v-if="loading">
      Chargement...
    </p>
    <p v-if="error">
      {{ error }}
    </p>
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
import {
  useAuthenticateStore,
  useWorkingTimesStore,
} from '../../app/store/store';

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
    const workingTimesStore = useWorkingTimesStore();
    const authStore = useAuthenticateStore();
    const loading = ref(true);
    const error = ref<string | null>(null);
    const selectedPeriod = ref('yearly');

    const fetchData = async () => {
      loading.value = true;
      error.value = null;
      const userId = authStore.user?.id;

      if (!userId) {
        error.value = 'Utilisateur non authentifié';
        loading.value = false;
        return;
      }

      try {
        switch (selectedPeriod.value) {
          case 'weekly':
            await workingTimesStore.fetchWeeklyWorkingTimes(userId);
            break;
          case 'monthly':
            await workingTimesStore.fetchMonthlyWorkingTimes(userId);
            break;
          case 'yearly':
          default:
            await workingTimesStore.fetchYearlyWorkingTimes(userId);
        }
      } catch (err) {
        error.value = 'Erreur lors du chargement des données';
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchData);

    const chartData = computed(() => {
      const labels = workingTimesStore.workingTimes.map(wt => {
        const startDate = new Date(wt.start);
        return startDate.toLocaleDateString();
      });

      const data = workingTimesStore.workingTimes.map(wt => {
        const start = new Date(wt.start);
        const end = new Date(wt.end);
        const duration = (end.getTime() - start.getTime()) / 3600000;
        return duration;
      });

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
      selectedPeriod,
      fetchData,
    };
  },
});
</script>

<style scoped></style>
