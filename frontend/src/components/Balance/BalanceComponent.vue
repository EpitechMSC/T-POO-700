<template>
  <div
    :class="bgColorClass"
    class="metronome-container relative w-96 h-72 mx-auto rounded-lg border-1 border-red-800 flex justify-center items-center"
  >
    <div
      class="metronome-needle absolute bottom-8 w-1 h-56 bg-black rounded-full origin-bottom transition-transform duration-1000 ease-in-out"
      :style="{ transform: `rotate(${computedAngle}deg)` }"
    ></div>
    <div
      class="work-percentage-label absolute bottom-1 text-lg font-semibold text-gray-800"
    >
      {{ (workedThisWeek / hoursPerWeek) * 100 }}% worked
    </div>
  </div>
</template>

<script>
import {
  useAuthenticateStore,
  useContratStore,
  useWorkingTimesStore,
} from '../../app/store/store';
import { defineComponent, onMounted, computed, watch, ref } from 'vue';

export default defineComponent({
  name: 'Balance',
  setup() {
    const contratStore = useContratStore();
    const authStore = useAuthenticateStore();
    const workingTimesStore = useWorkingTimesStore();

    const userId = computed(() => authStore.user?.id);

    const workedThisWeek = ref('');
    const hoursPerWeek = ref('');

    const fetchUserData = async () => {
      if (userId.value) {
        await workingTimesStore.fetchWorkingTimeStats(userId.value);
      }
    };

    onMounted(fetchUserData);
    const workingTimes = computed(() => workingTimesStore.stats);
    watch(
      () => workingTimes.value,
      newStats => {
        // Log only when stats are updated and available
        if (newStats && newStats.worked_this_week !== undefined) {
          workedThisWeek.value = newStats.worked_this_week;
        }
      }
    );

    const userData = computed(() => authStore.user);
    const contratId = userData.value.contrat;
    const fetchHoursPerWeek = async () => {
      await contratStore.getContratInfo(contratId);
    };
    onMounted(fetchHoursPerWeek);

    const contratTime = computed(() => contratStore.contratOfConnectedUser);
    watch(
      () => contratTime.value,
      contrat => {
        // Log only when stats are updated and available
        if (contrat && contrat.data !== undefined) {
          hoursPerWeek.value = contrat.data.temps;
        }
      }
    );
    // Computed property to calculate the needle's angle based on workedPercentage
    const computedAngle = computed(() => {
      const minAngle = -45;
      const maxAngle = 45;
      // Calculate the angle based on the percentage worked
      return (maxAngle - minAngle) * (workedThisWeek.value / 100) + minAngle;
    });

    const bgColorClass = computed(() => {
      if ((workedThisWeek.value / hoursPerWeek.value) * 100 > 80) {
        return 'bg-green-500'; // Green background if more than 80%
      } else {
        return 'bg-red-200'; // Default light gray background
      }
    });

    return {
      workedThisWeek,
      hoursPerWeek,
      computedAngle,
      bgColorClass,
    };
  },
});
</script>
