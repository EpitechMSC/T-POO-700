import {
  RouteRecordRaw,
  createRouter,
  createWebHistory,
  NavigationGuard,
  RouteLocationNormalized,
  NavigationGuardNext,
} from 'vue-router';
import UserDashboard from '../../pages/User/UserDashboard.vue';
import { useAuthenticateStore } from '../store/store';

interface RouteMeta {
  requiresAuth?: boolean;
}

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/login' },
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

const beforeEachGuard: NavigationGuard = (
  to: RouteLocationNormalized,
  _from: RouteLocationNormalized,
  next: NavigationGuardNext
) => {
  const authenticateStore = useAuthenticateStore();

  if (
    to.matched.some(
      (record: { meta: RouteMeta }) => (record.meta as RouteMeta).requiresAuth
    )
  ) {
    if (!authenticateStore.isAuthenticated) {
      next('/login');
    } else {
      next();
    }
  } else {
    next();
  }
};

router.beforeEach(beforeEachGuard);

export default router;
