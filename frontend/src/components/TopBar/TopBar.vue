<template>
  <div
    class="hello-bar flex justify-between h-24 bg-gray-100 items-center px-16 mb-10"
  >
    <h1 class="text-3xl font-semibold whitespace-nowrap dark:text-black">
      Bonjour, Commissaire
    </h1>
    <div
      class="hover:shadow-[0px_0px_20px_5px] hover:shadow-yellow-200 cursor-pointer hover:bg-gray-300 bg-gray-400 border-2 border-black p-2 transition ease-in-out duration-200"
      style="border-radius: 50%"
      @click="toggleBatSignal"
    >
      <img
        src="../../assets/batman-logo-circleless-11.png"
        class="w-32"
      >
    </div>

    <div class="clock flex items-center">
      <span class="flex">
        <p
          v-if="!isClocked"
          class="text-xl mr-1"
        >{{ timeOfClockedIn }} -</p>
        <p class="text-xl mr-2 w-20">{{ time }}</p>
      </span>
      <button
        class="bg-white p-2 rounded-lg w-14 h-14 flex justify-center items-center"
        @click="clocking"
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
              :stroke="isClocked ? 'black' : 'red'"
              stroke-width="4"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </g>
          <defs>
            <clipPath id="clip0_15_254">
              <rect
                width="34"
                height="34"
                fill="white"
              />
            </clipPath>
          </defs>
        </svg>
      </button>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue';
import {
  useWorkingTimesStore,
  useClocksStore,
  useSignalStore,
} from '../../app/store/store';

export default defineComponent({
  name: 'TopBar',
  setup() {
    const workingTimesStore = useWorkingTimesStore();
    const clockStore = useClocksStore();
    const signalStore = useSignalStore();

    const time = ref('');
    const date = ref('');
    const dateOfClock = ref({ start: '', end: '' });
    const isClocked = ref(true);
    const timeOfClockedIn = ref('');
    let workedToday = ref('');
    const batSignalStatus = ref('');

    const toggleBatSignal = async () => {
      signalStore.toggleStatus();
      updateStatus();
    };
    const updateStatus = async () => {
      batSignalStatus.value = await signalStore.getStatus();
    };
    const updateTime = () => {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0'); // Months are zero-based, so add 1
      const day = String(now.getDate()).padStart(2, '0');
      const hours = String(now.getHours()).padStart(2, '0');
      const minutes = String(now.getMinutes()).padStart(2, '0');
      const seconds = String(now.getSeconds()).padStart(2, '0');

      time.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
      date.value = `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`;
    };

    const clocking = async () => {
      const dataToSend = {
        clock: {
          time: date.value,
          status: isClocked.value,
        },
      };
      try {
        await clockStore.createClock(dataToSend);
      } catch (error) {
        console.error('There was an error during clocking', error);
      }
      // eslint-disable-next-line @typescript-eslint/no-unused-expressions
      isClocked.value
        ? ((dateOfClock.value.start = date.value),
          (timeOfClockedIn.value = time.value),
          (dateOfClock.value.end = ''))
        : (dateOfClock.value.end = date.value);

      isClocked.value = !isClocked.value;

      if (dateOfClock.value.end != '') {
        const workingTimeDataToSend = {
          working_time: {
            start: dateOfClock.value.start,
            end: dateOfClock.value.end,
            user: 1,
          },
        };
        try {
          await workingTimesStore.createWorkingTime(workingTimeDataToSend);
        } catch (error) {
          console.error(
            'There was an error when creating a working time',
            error
          );
        }
      }
    };

    onMounted(() => {
      workingTimesStore.getWorkingTimeById(1);
      updateTime();
      updateStatus();
      setInterval(updateTime, 1000);
      setInterval(updateStatus, 1000);
    });
    return {
      time,
      workedToday,
      clocking,
      isClocked,
      timeOfClockedIn,
      batSignalStatus,
      toggleBatSignal,
    };
  },
});
</script>

<style scoped>
.prout {
  color: rgb(255, 255, 122);
}
</style>
