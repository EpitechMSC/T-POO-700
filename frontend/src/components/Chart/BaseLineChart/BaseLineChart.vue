<template>
  <div class="base-line-chart">
    <Line :data="data" :options="options" />
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
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
import { BaseLineChartProps } from './BaseLineChart.types';

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
  name: 'BaseLineChart',
  components: {
    Line,
  },
  props: {
    data: {
      type: Object as PropType<BaseLineChartProps['data']>,
      required: true,
    },
    options: {
      type: Object as PropType<BaseLineChartProps['options']>,
      default: () => ({}),
    },
  },
});
</script>

<style scoped>
.base-line-chart {
  width: 100%;
}
</style>
