import {
  NavigationGuard,
  RouteLocationNormalized,
  NavigationGuardNext,
} from 'vue-router';
import { useAuthenticateStore } from '../store/store';

interface RouteMeta {
  requiresAuth?: boolean;
  roles?: string[];
}

const beforeEachGuard: NavigationGuard = (
  to: RouteLocationNormalized,
  _from: RouteLocationNormalized,
  next: NavigationGuardNext
) => {
  const authenticateStore = useAuthenticateStore();

  const userRole = authenticateStore.getUserRole;

  if (
    authenticateStore.isAuthenticated &&
    (to.name === 'Login' || to.name === 'Register')
  ) {
    next(`/users/${authenticateStore.user?.id}`);
  } else if (
    to.matched.some(record => (record.meta as RouteMeta).requiresAuth)
  ) {
    if (!authenticateStore.isAuthenticated) {
      next('/login');
    } else {
      const requiredRoles = (to.meta as RouteMeta).roles;
      if (requiredRoles && !requiredRoles.includes(userRole || '')) {
        next('/');
      } else {
        next();
      }
    }
  } else {
    next();
  }
};

export default beforeEachGuard;
