<template>
  <div class="w-full">
    <div class="flex justify-between mb-4">
      <select v-model="selectedPeriod" @change="fetchData">
        <option value="yearly">Année</option>
        <option value="monthly">Mensuel</option>
        <option value="weekly">Hebdomadaire</option>
      </select>
    </div>
    <BaseLineChart
      v-if="!loading && chartData"
      :data="chartData"
      :options="chartOptions"
      class="w-full"
    />
    <p v-if="loading">Chargement...</p>
    <p v-if="error">
      {{ error }}
    </p>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue';
import {
  useAuthenticateStore,
  useWorkingTimesStore,
} from '../../app/store/store';
import { ChartData, ChartOptions } from 'chart.js';
import BaseLineChart from './BaseLineChart/BaseLineChart.vue';

export default defineComponent({
  name: 'WorkingTimeChart',
  components: {
    BaseLineChart,
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
      } catch {
        error.value = 'Erreur lors du chargement des données';
      } finally {
        loading.value = false;
      }
    };

    onMounted(fetchData);

    const chartData = computed<ChartData<'line', number[], unknown>>(() => {
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

    const chartOptions = computed<ChartOptions<'line'>>(() => ({
      responsive: true,
      plugins: {
        legend: {
          position: 'top' as const,
        },
        title: {
          display: true,
          text: 'Heures de Travail',
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: 'Heures',
          },
        },
        x: {
          title: {
            display: true,
            text: 'Date',
          },
        },
      },
    }));

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
