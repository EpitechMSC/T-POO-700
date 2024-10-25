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
      {{ ((workedThisWeek / hoursPerWeek) * 100).toFixed(0) }}% worked
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
    const contratId = ref('');

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
    watch(
      () => userData.value,
      user => {
        if (user && user.contrat !== undefined) {
          contratId.value = user.contrat;
        }
      }
    );
    watch(
      () => contratId.value,
      id => {
        const fetchHoursPerWeek = async () => {
          await contratStore.getContratInfo(id);
        };
        fetchHoursPerWeek();
      }
    );

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
      const targetPercentage = 1; // 100 % correspond à 0°

      // Calcul de l'angle centré sur 0° pour 100 %
      let angle =
        (maxAngle - minAngle) *
          (workedThisWeek.value / hoursPerWeek.value - targetPercentage) +
        0;

      // Limiter l'angle entre minAngle et maxAngle
      angle = Math.max(minAngle, Math.min(angle, maxAngle));

      return angle;
    });

    const bgColorClass = computed(() => {
      if ((workedThisWeek.value / hoursPerWeek.value) * 100 > 90) {
        return 'bg-gradient-to-tr from-green-600 to-green-400'; // Green background if more than 80%
      } else if ((workedThisWeek.value / hoursPerWeek.value) * 100 > 60) {
        return 'bg-gradient-to-tr from-orange-400 to-orange-200'; // Yellow background if more than 50%
      } else {
        return 'bg-gradient-to-tr from-red-900 to-red-400'; // else it RED ✨ !
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
