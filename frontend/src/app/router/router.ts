import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import HomePage from '../../pages/Home/HomePage.vue'; // Assurez-vous que le chemin est correct
// import User from '../pages/User.vue'; // Importez votre page d'utilisateur
// import Clock from '../pages/Clock.vue'; // Importez votre page d'horloge
// import WorkingTime from '../pages/WorkingTime.vue'; // Importez votre page de temps de travail

const routes: Array<RouteRecordRaw> = [
  { path: '/', name: 'Home', component: HomePage },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
