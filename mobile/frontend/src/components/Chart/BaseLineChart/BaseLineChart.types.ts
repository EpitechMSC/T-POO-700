import { ChartData, ChartOptions } from 'chart.js';

export interface BaseLineChartProps {
  data: ChartData<'line', number[], unknown>;
  options?: ChartOptions<'line'>;
}
