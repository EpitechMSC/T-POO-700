<template>
  <BatSignal />
  <TopBar />
  <main class="p-6 my-12">
    <SummaryCard />
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <WorkingTimeChart />
      <WorkingTimeList />
    </div>
  </main>
</template>

<script src="./UserDashboard.ts"></script>
<style src="./UserDashboard.css"></style>
