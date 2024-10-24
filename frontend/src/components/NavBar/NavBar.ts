import { defineComponent, computed } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
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
        (page === 'times' && currentPath === '/times')
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
    };
  },
});
