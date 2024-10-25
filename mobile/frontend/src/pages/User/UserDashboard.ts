import { defineComponent } from 'vue';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart/WorkingTimeChart.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import TopBar from '../../components/TopBar/TopBar.vue';
import BatSignal from '../../components/BatSignalBar/BatSignal.vue';

export default defineComponent({
  name: 'UserDashboardPage',
  components: {
    TopBar,
    SummaryCard,
    WorkingTimeChart,
    WorkingTimeList,
    BatSignal,
  },
});
