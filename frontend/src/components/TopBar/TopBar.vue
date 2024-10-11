<template>
  <div
    class="hello-bar flex justify-between h-24 bg-gray-100 items-center px-16 mb-10"
  >
    <h1 class="text-3xl font-semibold whitespace-nowrap dark:text-white">
      Bonjour, Gilbert
    </h1>
    <div class="clock flex items-center">
      <p class="text-xl mr-2 w-20">{{ time }}</p>
      <button
        class="bg-white p-2 rounded-lg w-14 h-14 flex justify-center items-center"
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
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue';
import { useWorkingTimesStore } from '../../app/store/store';

export default defineComponent({
  name: 'TopBar',
  setup() {
    const workingTimesStore = useWorkingTimesStore();

    const time = ref('');
    var workedToday = ref('');

    const updateTime = () => {
      const now = new Date();
      const hours = now.getHours();
      const minutes = now.getMinutes();
      const seconds = now.getSeconds();

      time.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    };

    onMounted(() => {
      workingTimesStore.getWorkingTimeById(1);

      console.log(workingTimesStore);

      updateTime();
      setInterval(updateTime, 1000);
    });
    return {
      time,
      workedToday,
    };
  },
});
</script>

<style scoped></style>
