<template>
  <div>
    <!-- ------------------User-Bar----------------- -->
    <TopBar />

    <!-- ------------------Hello-Bar----------------- -->

    <!-- ------------------Top Content Components----------------- -->
    <div class="flex w-full justify-around">
      <CardComponent data="4:20" text="Worked today" />
      <CardComponent data="3438" text="Number of clocked" />
      <CardComponent data="1719" text="Working times" />
      <CardComponent data="124:20" text="Worked this week" />
    </div>

    <!-- ------------------Content Components----------------- -->
    <div class="flex w-full h-1/4">
      <WorkingTimeChart />
      <!-- <UserList /> -->
      <WorkingTimeList />
    </div>
  </div>
</template>

<script>
import { defineComponent, onMounted, ref } from 'vue';
import UserList from '../../components/Users/UserList.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import ClockList from '../../components/Clocks/ClockList.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart.vue';
import CardComponent from '../../components/Card/CardComponent.vue';
import { useWorkingTimesStore } from '../../app/store/modules/workingTimes';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'HomePage',
  components: {
    UserList,
    ClockList,
    WorkingTimeList,
    WorkingTimeChart,
    CardComponent,
    TopBar, // Ajouter TopBar ici
  },
  setup() {
    // stores
    const workingTimesStore = useWorkingTimesStore();

    const time = ref(''); // Créer une variable réactive pour l'heure
    var workedToday = ref('');

    // Fonction pour mettre à jour l'heure
    const updateTime = () => {
      const now = new Date(); // Obtenir la date et l'heure actuelles
      const hours = now.getHours(); // Obtenir l'heure actuelle (0-23)
      const minutes = now.getMinutes(); // Obtenir les minutes actuelles (0-59)
      const seconds = now.getSeconds(); // Obtenir les secondes actuelles (0-59)

      // Formater l'heure sous forme de chaîne
      time.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    };

    // Mettre à jour l'heure immédiatement lorsque le composant est monté
    onMounted(() => {
      //fetch stores
      workingTimesStore.getWorkingTimeById(1);
      updateTime(); // Définir l'heure initiale
      setInterval(updateTime, 1000); // Mettre à jour l'heure chaque seconde
    });
    return {
      time,
      workedToday,
    };
  },
});
</script>

<style src="./HomePage.style.css"></style>
