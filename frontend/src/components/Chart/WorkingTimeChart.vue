<template>
  <div class="w-full">
    <div class="flex justify-between mb-4">
      <select v-model="selectedPeriod" @change="fetchData">
        <option value="total">Total</option>
        <option value="weekly">Hebdomadaire</option>
        <option value="monthly">Mensuel</option>
      </select>
    </div>
    <LineChart
      v-if="chartData"
      :data="chartData"
      :options="chartOptions"
      class="w-full"
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
import { useRoute } from 'vue-router';

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
    const selectedPeriod = ref('total');
    const route = useRoute();
    const userId = route.params.id as string;

    const fetchData = async () => {
      loading.value = true;
      error.value = null;
      try {
        switch (selectedPeriod.value) {
          case 'weekly':
            await store.fetchWeeklyWorkingTimes(userId);
            break;
          case 'monthly':
            await store.fetchMonthlyWorkingTimes(userId);
            break;
          default:
            await store.fetchYearlyWorkingTimes(userId);
        }
      } catch (err) {
        error.value = 'Erreur lors du chargement des données';
      }
      loading.value = false;
    };

    onMounted(fetchData);

    const chartData = computed(() => {
      const labels = store.workingTimes.map(wt => {
        const startDate = new Date(wt.start);
        return startDate.toLocaleDateString();
      });

      const data = store.workingTimes.map(wt => {
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
