<template>
  <div
    :class="bgColorClass"
    class="metronome-container relative h-72 mx-auto rounded-lg border-1 border-red-800 flex justify-center items-center"
  >
    <div
      class="metronome-needle absolute bottom-8 w-1 h-56 bg-black rounded-full origin-bottom transition-transform duration-1000 ease-in-out"
      :style="{ transform: `rotate(${computedAngle}deg)` }"
    ></div>
    <div
      class="work-percentage-label absolute bottom-1 text-lg font-semibold text-gray-800"
    >
      {{ percentageWorked }}% worked
    </div>
  </div>
</template>

<script>
import {
  useAuthenticateStore,
  useWorkingTimesStore,
} from '../../app/store/store';
import { defineComponent, onMounted, computed, ref, watch } from 'vue';

export default defineComponent({
  name: 'Balance',
  setup() {
    const authStore = useAuthenticateStore();
    const workingTimesStore = useWorkingTimesStore();

    // Reactive Variables
    const workedThisWeek = ref(0);
    const hoursPerWeek = ref(0);

    // Get User ID and User Contract
    const userId = computed(() => authStore.user?.id);
    const userContract = computed(() => authStore.user?.contrat);

    console.log(userContract.value);

    // Set hours per week based on user contract value
    const setHoursPerWeek = () => {
      switch (userContract.value) {
        case 1:
          hoursPerWeek.value = 35;
          break;
        case 2:
          hoursPerWeek.value = 39;
          break;
        case 3:
          hoursPerWeek.value = 42;
          break;
        default:
          hoursPerWeek.value = 0;
      }
    };

    const fetchUserData = async () => {
      try {
        if (userId.value) {
          await workingTimesStore.fetchWorkingTimeStats(userId.value);
        }
        setHoursPerWeek();
      } catch (error) {
        console.error('Failed to fetch data:', error);
      }
    };

    onMounted(fetchUserData);

    const workingTimes = computed(() => workingTimesStore.stats);

    const percentageWorked = computed(() => {
      if (hoursPerWeek.value === 0) return 0;
      return ((workedThisWeek.value / hoursPerWeek.value) * 100).toFixed(0);
    });

    const computedAngle = computed(() => {
      const minAngle = -45;
      const maxAngle = 45;
      const targetPercentage = 1; // 100% corresponds to 0°

      const angle =
        (maxAngle - minAngle) *
          (workedThisWeek.value / hoursPerWeek.value - targetPercentage) +
        0;

      return Math.max(minAngle, Math.min(angle, maxAngle));
    });

    const bgColorClass = computed(() => {
      const percentage = (workedThisWeek.value / hoursPerWeek.value) * 100;
      if (percentage > 90) {
        return 'bg-gradient-to-tr from-green-600 to-green-400';
      } else if (percentage > 60) {
        return 'bg-gradient-to-tr from-orange-400 to-orange-200';
      } else {
        return 'bg-gradient-to-tr from-red-900 to-red-400';
      }
    });

    const updateValues = () => {
      if (workingTimes.value) {
        workedThisWeek.value = workingTimes.value.worked_this_week || 0;
      }
    };

    watch(workingTimes, updateValues, { immediate: true });

    return {
      percentageWorked,
      computedAngle,
      bgColorClass,
    };
  },
});
</script>
