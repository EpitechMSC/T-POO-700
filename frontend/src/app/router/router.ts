import { RouteRecordRaw, createRouter, createWebHistory } from 'vue-router';
import HomePageComponent from '../../pages/Home/HomePage.vue';
import UserDashboard from '../../pages/User/UserDashboard.vue';

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/users/:id' },
  { path: '/home', name: 'Home', component: HomePageComponent },
  { path: '/users/:id', name: 'User', component: UserDashboard },
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
