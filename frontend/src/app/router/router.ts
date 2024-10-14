import { RouteRecordRaw, createRouter, createWebHistory } from 'vue-router';
import HomePageComponent from '../../pages/Home/HomePage.vue';
import UserDashboard from '../../pages/User/UserDashboard.vue';
import { useAuthenticateStore } from '../store/store';

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/login' },
  { path: '/home', name: 'Home', component: HomePageComponent },
  {
    path: '/users/:id',
    name: 'User',
    component: UserDashboard,
    meta: { requiresAuth: true },
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../../pages/Login/LoginPage.vue'),
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../../pages/Register/RegisterPage.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  const authenticateStore = useAuthenticateStore();

  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!authenticateStore.isAuthenticated) {
      next('/login');
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
