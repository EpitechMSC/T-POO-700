import { defineComponent } from 'vue';
import UserList from '../../components/Users/UserList.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import ClockList from '../../components/Clocks/ClockList.vue';

export default defineComponent({
  name: 'HomePage',
  components: {
    UserList,
    ClockList,
    WorkingTimeList,
  },
});
