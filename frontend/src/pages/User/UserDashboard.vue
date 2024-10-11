<template>
  <NavBar />
  <TopBar />
  <main class="p-6 my-12">
    <SummaryCard />
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <WorkingTimeChart />
      <WorkingTimeList />
    </div>
  </main>
</template>

<script>
import { defineComponent, onMounted, ref } from 'vue';
import NavBar from '../../components/NavBar/NavBar.vue';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'UserDashboardPage',
  components: {
    NavBar,
    TopBar,
    SummaryCard,
    WorkingTimeChart,
    WorkingTimeList,
  },
});
</script>

<style scoped></style>
