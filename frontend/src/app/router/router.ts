import { RouteRecordRaw, createRouter, createWebHistory } from 'vue-router';
import UserDashboard from '../../pages/User/UserDashboard.vue';
import SettingsPage from '../../pages/Settings/SettingsPage.vue';
import WorkingTimesPage from '../../pages/WorkingTimes/WorkingTimesPage.vue';
import Calendar from '../../pages/Calendar/Calendar.vue';
import beforeEachGuard from './auth-guard';

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/login' },
  {
    path: '/users/:id',
    name: 'User',
    component: UserDashboard,
    meta: { requiresAuth: true },
  },
  {
    path: '/times',
    name: 'Working Times',
    component: WorkingTimesPage,
    meta: { requiresAuth: true },
  },
  {
    path: '/calendar',
    name: 'Calendar',
    component: Calendar,
    meta: { requiresAuth: true },
  },
  {
    path: '/users/:id/settings',
    name: 'Settings',
    component: SettingsPage,
    meta: { requiresAuth: true }, //, roles: ['Supervisor', 'Manager']
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

router.beforeEach(beforeEachGuard);

export default router;
