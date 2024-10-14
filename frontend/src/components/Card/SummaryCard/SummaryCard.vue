<template>
  <section class="summary__grid">
    <div v-for="(card, index) in cards" :key="index" class="app-card">
      <div :class="'card__icon card__icon--' + card.type">
        <i :class="card.icon" style="font-size: 1.5rem"></i>
      </div>
      <div class="card__content">
        <p class="card__title">{{ card.title }}</p>
        <h4 class="card__amount">{{ card.amount }}</h4>
      </div>
      <div class="card__footer">
        <p class="card__footer-text">
          <strong :class="card.isPositive ? 'text-green-500' : 'text-red-500'">
            {{ card.percentageChange }}
          </strong>
          &nbsp;than last month
        </p>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useWorkingTimesStore } from '../../../app/store/store';

export default defineComponent({
  name: 'SummaryCard',
  setup() {
    const route = useRoute();
    const workingTimesStore = useWorkingTimesStore();
    const userId = route.params.id as string;

    const fetchUserData = async () => {
      await workingTimesStore.fetchWorkingTimeStats(userId);
    };

    onMounted(fetchUserData);

    const userStats = computed(() => workingTimesStore.stats);

    const cards = computed(() => {
      if (!userStats.value) {
        return [
          {
            title: 'Worked today',
            amount: '0:00',
            percentageChange: 'N/A',
            isPositive: false,
            type: 'worked_today',
            icon: 'fas fa-clock',
          },
          {
            title: 'Number of clocked',
            amount: '0',
            percentageChange: 'N/A',
            isPositive: false,
            type: 'clocked',
            icon: 'fas fa-users',
          },
          {
            title: 'Working times',
            amount: '0',
            percentageChange: 'N/A',
            isPositive: false,
            type: 'working_times',
            icon: 'fas fa-briefcase',
          },
          {
            title: 'Worked this week',
            amount: '0:00',
            percentageChange: 'N/A',
            isPositive: false,
            type: 'worked_week',
            icon: 'fas fa-calendar-week',
          },
        ];
      }

      const { worked_today, worked_this_week, total_days_worked } =
        userStats.value;

      const percentageChange = '+5%';

      return [
        {
          title: 'Worked today',
          amount: `${Math.floor(worked_today)}:${Math.round(
            (worked_today % 1) * 60
          )
            .toString()
            .padStart(2, '0')}`,
          percentageChange,
          isPositive: true,
          type: 'worked_today',
          icon: 'fas fa-clock',
        },
        {
          title: 'Number of clocked',
          amount: workingTimesStore.workingTimeCount.toString(),
          percentageChange: '-3%',
          isPositive: false,
          type: 'clocked',
          icon: 'fas fa-users',
        },
        {
          title: 'Working times',
          amount: total_days_worked.toString(),
          percentageChange,
          isPositive: true,
          type: 'working_times',
          icon: 'fas fa-briefcase',
        },
        {
          title: 'Worked this week',
          amount: `${Math.floor(worked_this_week)}:${Math.round(
            (worked_this_week % 1) * 60
          )
            .toString()
            .padStart(2, '0')}`,
          percentageChange: '+12%',
          isPositive: true,
          type: 'worked_week',
          icon: 'fas fa-calendar-week',
        },
      ];
    });

    return {
      cards,
    };
  },
});
</script>

<style scoped>
.summary__grid {
  @apply mb-12 grid gap-y-10 gap-x-6 md:grid-cols-2 xl:grid-cols-4;
}

.app-card {
  @apply relative flex flex-col bg-clip-border rounded-xl bg-white text-gray-700 shadow-md mb-5 h-full;
}

/* Card */
.card__icon {
  @apply bg-clip-border mx-4 rounded-xl overflow-hidden shadow-lg absolute -mt-4 grid h-16 w-16 place-items-center;
}

.card__icon--worked_today {
  @apply bg-gradient-to-tr from-blue-600 to-blue-400 text-white shadow-blue-500/40;
}

.card__icon--clocked {
  @apply bg-gradient-to-tr from-pink-600 to-pink-400 text-white shadow-pink-500/40;
}

.card__icon--working_times {
  @apply bg-gradient-to-tr from-green-600 to-green-400 text-white shadow-green-500/40;
}

.card__icon--worked_week {
  @apply bg-gradient-to-tr from-orange-600 to-orange-400 text-white shadow-orange-500/40;
}

.card__content {
  @apply p-4 text-right;
}

.card__title {
  @apply block antialiased font-sans text-sm leading-normal font-normal text-gray-500;
}

.card__amount {
  @apply block antialiased tracking-normal font-sans text-2xl font-semibold leading-snug text-gray-900;
}

.card__footer {
  @apply border-t border-gray-50 p-4;
}

.card__footer-text {
  @apply block antialiased font-sans text-base leading-relaxed font-normal text-gray-500;
}
</style>
