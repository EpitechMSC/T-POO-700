import { defineComponent } from 'vue';
import NavBar from '../../components/NavBar/NavBar.vue';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart/WorkingTimeChart.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'UserDashboardPage',
  components: {
    NavBar,
    TopBar,
    SummaryCard,
    WorkingTimeChart,
    WorkingTimeList,
  },
});
