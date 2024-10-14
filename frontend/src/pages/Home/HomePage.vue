<template>
  <div>
    <!-- ------------------User-Bar----------------- -->
    <TopBar />

    <!-- ------------------Hello-Bar----------------- -->
    <div
      class="hello-bar flex justify-between h-24 bg-grey items-center px-16 mb-10"
    >
      <h1 class="font-black text-5xl">Hello Gilbert</h1>
      <div class="clock flex items-center">
        <p class="text-xl mr-2 w-20">{{ time }}</p>
        <button
          class="skeuo bg-white p-2 rounded-lg w-14 h-14 flex justify-center items-center"
        >
          <svg
            width="34"
            height="34"
            viewBox="0 0 34 34"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <g clip-path="url(#clip0_15_254)">
              <path
                d="M17 8.50001V17L22.6666 19.8333M31.1666 17C31.1666 24.824 24.824 31.1667 17 31.1667C9.17595 31.1667 2.83331 24.824 2.83331 17C2.83331 9.17598 9.17595 2.83334 17 2.83334C24.824 2.83334 31.1666 9.17598 31.1666 17Z"
                stroke="#1E1E1E"
                stroke-width="4"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </g>
            <defs>
              <clipPath id="clip0_15_254">
                <rect width="34" height="34" fill="white" />
              </clipPath>
            </defs>
          </svg>
        </button>
      </div>
    </div>

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
