<template>
  <div>
    <!-- ------------------User-Bar----------------- -->
    <div class="user-bar flex justify-between h-[70px] items-center p-8">
      <div
        class="search-bar flex items-center border border-gray rounded-full px-4 py-2 bg-gray-50 h-min"
      >
        <svg
          class="w-5 h-5 text-gray-400 mr-2"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M21 21l-4.35-4.35m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z"
          ></path>
        </svg>
        <input
          type="text"
          placeholder="Search"
          class="outline-none bg-transparent text-gray-700 placeholder-gray-400 w-full"
        />
      </div>
      <div class="user-profile flex items-center">
        <p class="capitalize mr-2">gilbert</p>
        <img
          class="rounded-full w-10 h-10"
          src="../../assets/Capture d’écran 2023-10-09 150736.jpg"
        />
      </div>
    </div>

    <!-- ------------------Hello-Bar----------------- -->
    <div
      class="hello-bar flex justify-between h-24 bg-grey items-center px-16 mb-10"
    >
      <h1 class="font-black text-5xl">Hello Gilbert</h1>
      <div class="clock flex items-center">
        <p class="text-xl mr-2 w-20">{{ time }}</p>
        <button
          class="skeuo bg-white p-2 rounded-lg w-14 h-14 flex justify-center items-center"
        >
          <svg
            width="34"
            height="34"
            viewBox="0 0 34 34"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <g clip-path="url(#clip0_15_254)">
              <path
                d="M17 8.50001V17L22.6666 19.8333M31.1666 17C31.1666 24.824 24.824 31.1667 17 31.1667C9.17595 31.1667 2.83331 24.824 2.83331 17C2.83331 9.17598 9.17595 2.83334 17 2.83334C24.824 2.83334 31.1666 9.17598 31.1666 17Z"
                stroke="#1E1E1E"
                stroke-width="4"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </g>
            <defs>
              <clipPath id="clip0_15_254">
                <rect width="34" height="34" fill="white" />
              </clipPath>
            </defs>
          </svg>
        </button>
      </div>
    </div>

    <!-- ------------------top-Content-Components----------------- -->
    <div class="flex w-full justify-around">
      <CardComponent data="4:20" text="Worked today" />
      <CardComponent data="3438" text="Number of clocked" />
      <CardComponent data="1719" text="Working times" />
      <CardComponent data="124:20" text="Worked this week" />
    </div>

    <!-- ------------------Content-Components----------------- -->
    <div class="flex w-full h-1/4">
      <WorkingTimeChart class="w-4/5" />
      <!--  <UserList />-->
      <WorkingTimeList />
    </div>
  </div>
</template>

<script>
import { defineComponent, onBeforeUnmount, onMounted, ref } from 'vue';
import UserList from '../../components/Users/UserList.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import ClockList from '../../components/Clocks/ClockList.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart.vue';
import CardComponent from '../../components/Card/CardComponent.vue';
import { useWorkingTimesStore } from '../../app/store/modules/workingTimes';

export default defineComponent({
  name: 'HomePage',
  components: {
    UserList,
    ClockList,
    WorkingTimeList,
    WorkingTimeChart,
    CardComponent,
  },
  setup() {
    // stores
    const workingTimesStore = useWorkingTimesStore();

    const time = ref(''); // Create a reactive variable for the time

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

      updateTime(); // Set the initial time
      setInterval(updateTime, 1000); // Update time every second
    });
    return {
      time,
    };
  },
});
</script>
<style src="./HomePage.style.css"></style>
