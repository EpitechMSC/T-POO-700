<template>
  <section class="summary__grid">
    <div v-for="(card, index) in cards" :key="index" class="app-card">
      <div :class="'card__icon card__icon--' + card.type">
        <i :class="card.icon" style="font-size: 1.5rem" />
      </div>
      <div class="card__content">
        <p class="card__title">
          {{ card.title }}
        </p>
        <h4 class="card__amount">
          {{ card.amount }}
        </h4>
      </div>
      <div class="border-t border-gray-50 p-4">
        <p
          class="block antialiased font-sans text-base leading-relaxed font-normal text-gray-500"
        >
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
import { useAuthenticateStore } from '../../../app/store/store';
import { useWorkingTimesStore } from '../../../app/store/store';

export default defineComponent({
  name: 'SummaryCard',
  setup() {
    const authenticateStore = useAuthenticateStore();
    const workingTimesStore = useWorkingTimesStore();

    const userId = computed(() => authenticateStore.user?.id);

    const fetchUserData = async () => {
      if (userId.value) {
        await workingTimesStore.fetchWorkingTimeStats(userId.value);
      }
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

    const cardIconClass = (type: string) => {
      switch (type) {
        case 'worked_today':
          return 'bg-gradient-to-tr from-blue-600 to-blue-400 text-white shadow-blue-500/40';
        case 'clocked':
          return 'bg-gradient-to-tr from-pink-600 to-pink-400 text-white shadow-pink-500/40';
        case 'working_times':
          return 'bg-gradient-to-tr from-green-600 to-green-400 text-white shadow-green-500/40';
        case 'worked_week':
          return 'bg-gradient-to-tr from-orange-600 to-orange-400 text-white shadow-orange-500/40';
        default:
          return '';
      }
    };

    return {
      cards,
      cardIconClass,
    };
  },
});
</script>
