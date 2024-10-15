import {
  defineComponent,
  ref,
  onMounted,
  onBeforeUnmount,
  computed,
  getCurrentInstance,
} from 'vue';
import { useAuthenticateStore } from '../../app/store/store';
import router from '../../app/router/router';

export default defineComponent({
  name: 'NavBarComponent',
  setup() {
    const store = useAuthenticateStore();
    const isDropdownOpen = ref(false);
    const instance = getCurrentInstance();

    const toggleUserDropdown = (e: MouseEvent) => {
      e.stopPropagation();
      isDropdownOpen.value = !isDropdownOpen.value;
    };

    const closeDropdown = () => {
      isDropdownOpen.value = false;
    };

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
        await router.push('/login');
      } catch (error) {
        console.error('Logout failed:', error);
      }
    };

    const stopPropagation = (event: Event) => {
      event.stopPropagation();
    };

    const handleClickOutside = (event: MouseEvent) => {
      const dropdown = instance?.refs.dropdown as HTMLElement;
      if (dropdown && !dropdown.contains(event.target as Node)) {
        closeDropdown();
      }
    };

    onMounted(() => {
      document.addEventListener('click', handleClickOutside);
    });

    onBeforeUnmount(() => {
      document.removeEventListener('click', handleClickOutside);
    });

    const user = computed(() => store.user);

    return {
      isDropdownOpen,
      toggleUserDropdown,
      isActive,
      logout,
      stopPropagation,
      user,
    };
  },
});
