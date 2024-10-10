<template>
  <div class="text-center h-6">
    <h2 class="text-2xl" style="font-family: 'Inter', sans-serif">
      Évolution du temps de travail
    </h2>
    <LineChart v-if="chartData" :data="chartData" :options="chartOptions" />
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

    const fetchData = async () => {
      loading.value = true;
      error.value = null;
      await store.fetchWorkingTimes();
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
    };
  },
});
</script>

<style scoped></style>
