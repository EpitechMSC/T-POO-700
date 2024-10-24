import { defineComponent, computed } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
import router from '../../app/router/router';
import { useDropdown } from '../../app/hook/useDropdown';

export default defineComponent({
  name: 'NavBarComponent',
  setup() {
    const store = useAuthenticateStore();
    const { isDropdownOpen, toggleDropdown, closeDropdown, stopPropagation } =
      useDropdown();

    const isActive = (page: string) => {
      const currentPath = window.location.pathname;
      return (
        (page === 'home' && currentPath === '/') ||
        (page === 'home' && currentPath === '/users/:id') || // --- à revoir --- //
        (page === 'times' && currentPath === '/times') ||
        (page === 'calendar' && currentPath === '/calendar')
      );
    };

    const logout = async () => {
      try {
        store.logout();
        closeDropdown();
        await router.push('/login');
      } catch (error) {
        console.error('Logout failed:', error);
      }
    };

    const user = computed(() => store.user);

    return {
      isDropdownOpen,
      toggleDropdown,
      isActive,
      logout,
      stopPropagation,
      user,
    };
  },
});
