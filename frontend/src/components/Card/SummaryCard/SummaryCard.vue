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

<script>
export default {
  data() {
    return {
      workingTimes: [
        { id: 1, start: '08:00', end: '12:00', user: 1 },
        { id: 2, start: '13:00', end: '17:00', user: 1 },
        { id: 3, start: '09:00', end: '12:00', user: 2 },
      ],
      cards: [
        {
          title: 'Worked today',
          amount: '4:20',
          percentageChange: '+5%',
          isPositive: true,
          type: 'worked_today',
          icon: 'fas fa-clock',
        },
        {
          title: 'Number of clocked',
          amount: '3438',
          percentageChange: '-3%',
          isPositive: false,
          type: 'clocked',
          icon: 'fas fa-users',
        },
        {
          title: 'Working times',
          amount: '1719',
          percentageChange: '+8%',
          isPositive: true,
          type: 'working_times',
          icon: 'fas fa-briefcase',
        },
        {
          title: 'Worked this week',
          amount: '124:20',
          percentageChange: '+12%',
          isPositive: true,
          type: 'worked_week',
          icon: 'fas fa-calendar-week',
        },
      ],
    };
  },
  methods: {
    calculateWorkedToday() {
      const today = new Date().toLocaleDateString();
      const totalMinutes = this.workingTimes
        .filter(work => {
          const startDate = new Date(`2024-10-11T${work.start}`);
          return startDate.toLocaleDateString() === today;
        })
        .reduce((total, work) => {
          const startTime = new Date(`2024-10-11T${work.start}`);
          const endTime = new Date(`2024-10-11T${work.end}`);
          const diff = (endTime - startTime) / 60000;
          return total + diff;
        }, 0);

      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      return `${hours}:${minutes < 10 ? '0' + minutes : minutes}`;
    },
  },
  created() {
    this.cards[0].amount = this.calculateWorkedToday();
  },
};
</script>

<style scoped>
.summary__grid {
  @apply mb-12 grid gap-y-10 gap-x-6 md:grid-cols-2 xl:grid-cols-4;
}

/* Style général des cartes */
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
