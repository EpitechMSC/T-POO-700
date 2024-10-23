import { defineComponent } from 'vue';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'WorkingTimesPage',
  components: {
    TopBar,
    SummaryCard,
    WorkingTimeList,
  },
});
