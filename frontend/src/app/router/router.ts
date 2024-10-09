import { RouteRecordRaw, createRouter, createWebHistory } from 'vue-router';
import HomePageComponent from '../../pages/Home/HomePage.vue';

const routes: Array<RouteRecordRaw> = [
  { path: '/home', name: 'Home', component: HomePageComponent },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../../pages/Login/LoginPage.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
