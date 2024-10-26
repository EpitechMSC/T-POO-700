<template>
  <section class="mb-12 grid gap-y-5 gap-x-4 grid-cols-12">
    <div
      v-for="(card, index) in cards"
      :key="index"
      class="relative flex flex-col bg-clip-border rounded-xl col-span-12 md:col-span-6 xl:col-span-3 bg-white text-gray-700 shadow-md mb-5 h-full"
    >
      <div
        :class="[
          'card__icon mx-4 rounded-xl overflow-hidden shadow-lg absolute -mt-4 grid h-16 w-16 place-items-center',
          cardIconClass(card.type),
        ]"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          stroke-1
          md:stroke-2
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            :d="card.icon"
            clip-rule="evenodd"
          />
        </svg>
      </div>
      <div class="p-4 text-right">
        <p
          class="block antialiased font-sans text-sm leading-normal font-normal text-gray-500"
        >
          {{ card.title }}
        </p>
        <h4
          class="block antialiased tracking-normal font-black font-sans text-7xl font-semibold leading-snug text-gray-900"
        >
          {{ card.amount }}
        </h4>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, computed, watch } from 'vue';
import {
  useAuthenticateStore,
  useWorkingTimesStore,
} from '../../../app/store/store';

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

    watch(
      () => userId.value,
      newUserId => {
        if (newUserId) {
          fetchUserData();
        }
      },
      { immediate: true }
    );

    const userStats = computed(() => workingTimesStore.stats);

    const cards = computed(() => {
      if (!userStats.value) {
        return [
          {
            title: 'Worked today',
            amount: '0:00',
            type: 'worked_today',
            icon: 'M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25ZM12.75 6a.75.75 0 0 0-1.5 0v6c0 .414.336.75.75.75h4.5a.75.75 0 0 0 0-1.5h-3.75V6Z',
          },
          {
            title: 'Number of Working times',
            amount: '0',
            type: 'clocked',
            icon: 'M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.094 1.976 1.057 1.976 2.192V16.5A2.25 2.25 0 0 1 18 18.75h-2.25m-7.5-10.5H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V18.75m-7.5-10.5h6.375c.621 0 1.125.504 1.125 1.125v9.375m-8.25-3 1.5 1.5 3-3.75',
          },
          {
            title: 'total days worked',
            amount: '0',
            type: 'working_times',
            icon: 'M20.25 14.15v4.25c0 1.094-.787 2.036-1.872 2.18-2.087.277-4.216.42-6.378.42s-4.291-.143-6.378-.42c-1.085-.144-1.872-1.086-1.872-2.18v-4.25m16.5 0a2.18 2.18 0 0 0 .75-1.661V8.706c0-1.081-.768-2.015-1.837-2.175a48.114 48.114 0 0 0-3.413-.387m4.5 8.006c-.194.165-.42.295-.673.38A23.978 23.978 0 0 1 12 15.75c-2.648 0-5.195-.429-7.577-1.22a2.016 2.016 0 0 1-.673-.38m0 0A2.18 2.18 0 0 1 3 12.489V8.706c0-1.081.768-2.015 1.837-2.175a48.111 48.111 0 0 1 3.413-.387m7.5 0V5.25A2.25 2.25 0 0 0 13.5 3h-3a2.25 2.25 0 0 0-2.25 2.25v.894m7.5 0a48.667 48.667 0 0 0-7.5 0M12 12.75h.008v.008H12v-.008Z',
          },
          {
            title: 'Worked this week',
            amount: '0:00',
            type: 'worked_week',
            icon: 'M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z',
          },
        ];
      }

      const { worked_today, worked_this_week, total_days_worked } =
        userStats.value;

      return [
        {
          title: 'Worked today',
          amount: `${Math.floor(worked_today)}:${Math.round(
            (worked_today % 1) * 60
          )
            .toString()
            .padStart(2, '0')}`,
          type: 'worked_today',
          icon: 'M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25ZM12.75 6a.75.75 0 0 0-1.5 0v6c0 .414.336.75.75.75h4.5a.75.75 0 0 0 0-1.5h-3.75V6Z',
        },
        {
          title: 'Number of Working times',
          amount: workingTimesStore.workingTimeCount.toString(),
          type: 'clocked',
          icon: 'M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.094 1.976 1.057 1.976 2.192V16.5A2.25 2.25 0 0 1 18 18.75h-2.25m-7.5-10.5H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V18.75m-7.5-10.5h6.375c.621 0 1.125.504 1.125 1.125v9.375m-8.25-3 1.5 1.5 3-3.75',
        },
        {
          title: 'total days worked',
          amount: total_days_worked.toString(),
          type: 'working_times',
          icon: 'M20.25 14.15v4.25c0 1.094-.787 2.036-1.872 2.18-2.087.277-4.216.42-6.378.42s-4.291-.143-6.378-.42c-1.085-.144-1.872-1.086-1.872-2.18v-4.25m16.5 0a2.18 2.18 0 0 0 .75-1.661V8.706c0-1.081-.768-2.015-1.837-2.175a48.114 48.114 0 0 0-3.413-.387m4.5 8.006c-.194.165-.42.295-.673.38A23.978 23.978 0 0 1 12 15.75c-2.648 0-5.195-.429-7.577-1.22a2.016 2.016 0 0 1-.673-.38m0 0A2.18 2.18 0 0 1 3 12.489V8.706c0-1.081.768-2.015 1.837-2.175a48.111 48.111 0 0 1 3.413-.387m7.5 0V5.25A2.25 2.25 0 0 0 13.5 3h-3a2.25 2.25 0 0 0-2.25 2.25v.894m7.5 0a48.667 48.667 0 0 0-7.5 0M12 12.75h.008v.008H12v-.008Z',
        },
        {
          title: 'Worked this week',
          amount: `${Math.floor(worked_this_week)}:${Math.round(
            (worked_this_week % 1) * 60
          )
            .toString()
            .padStart(2, '0')}`,
          type: 'worked_week',
          icon: 'M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z',
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
