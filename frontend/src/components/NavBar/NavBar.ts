import { defineComponent, computed } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
import { useDropdown } from '../../app/hook/useDropdown';
import BatSignal from '../../components/BatSignalBar/BatSignal.vue';

export default defineComponent({
  name: 'NavBarComponent',
  components: {
    BatSignal,
  },
  setup() {
    const store = useAuthenticateStore();
    const { isDropdownOpen, toggleDropdown, closeDropdown, stopPropagation } =
      useDropdown();

    const isActive = (page: string) => {
      const homepage = /^\/users\/\d+$/;
      const currentPath = window.location.pathname;
      return (
        (page === 'home' &&
          (currentPath === '/' || homepage.test(currentPath))) ||
        (page === 'times' && currentPath === '/times') ||
        (page === 'calendar' && currentPath === '/calendar')
      );
    };

    const logout = async () => {
      try {
        store.logout();
        closeDropdown();
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
      BatSignal,
    };
  },
});
