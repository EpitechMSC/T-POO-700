import { defineComponent, onMounted, ref } from 'vue';
import UserList from '../../components/Users/UserList.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import ClockList from '../../components/Clocks/ClockList.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart.vue';
import CardComponent from '../../components/Card/CardComponent.vue';
import { useWorkingTimesStore } from '../../app/store/modules/workingTimes';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'HomePage',
  components: {
    UserList,
    ClockList,
    WorkingTimeList,
    WorkingTimeChart,
    CardComponent,
    TopBar,
  },
  setup() {
    // stores
    const workingTimesStore = useWorkingTimesStore();

    const time = ref(''); // Create a reactive variable for the time
    const workedToday = ref('');

    // Function to update the time
    const updateTime = () => {
      const now = new Date(); // Get the current date and time
      const hours = now.getHours(); // Get the current hour (0-23)
      const minutes = now.getMinutes(); // Get the current minutes (0-59)
      const seconds = now.getSeconds(); // Get the current seconds (0-59)

      // Format the time as a string
      time.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    };

    // Update the time immediately when the component is mounted
    onMounted(() => {
      //fetch stores
      workingTimesStore.getWorkingTimeById(1);

      console.log(workingTimesStore);

      updateTime(); // Set the initial time
      setInterval(updateTime, 1000); // Update time every second
    });
    return {
      time,
      workedToday,
    };
  },
});
