<template>
  <nav class="bg-white border-gray-200 shadow-sm dark:bg-gray-900">
    <div
      class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4"
    >
      <a
        href="/"
        class="flex items-center space-x-3 rtl:space-x-reverse"
      >
        <img
          src="https://epitech.bj/wp-content/uploads/2020/03/EPI-LOGO-SIGNATURE-2018.png"
          class="h-8"
          alt="Epitech Logo"
        >
        <span
          class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white"
        >Time Manager</span>
      </a>
      <div
        class="flex items-center md:order-2 space-x-3 md:space-x-0 rtl:space-x-reverse relative"
      >
        <button
          type="button"
          class="flex text-sm dark:bg-gray-800 rounded-full md:me-0 focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
          :aria-expanded="isDropdownOpen.toString()"
          @click="toggleUserDropdown"
        >
          <span class="sr-only">Open user menu</span>
          <svg
            class="w-8 h-8 dark:text-white"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke="currentColor"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
        </button>
        <div
          v-show="isDropdownOpen"
          ref="dropdown"
          class="absolute top-6 right-0 z-50 mt-2 text-base list-none bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700 dark:divide-gray-600"
          @click="e => stopPropagation(e)"
        >
          <div class="px-4 py-3">
            <span class="block text-sm text-gray-900 dark:text-white">{{
              user?.username || 'Guest'
            }}</span>
            <span
              class="block text-sm text-gray-500 truncate dark:text-gray-400"
            >{{ user?.email || 'Not logged in' }}</span>
          </div>
          <ul class="py-2">
            <li>
              <a
                href="#"
                class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                @click.prevent="goToSettings"
              >Settings</a>
            </li>
            <li>
              <a
                href="#"
                class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                @click.prevent="logout"
              >Sign out</a>
            </li>
          </ul>
        </div>
        <button
          type="button"
          class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
          aria-controls="navbar-user"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="w-5 h-5"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 17 14"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M1 1h15M1 7h15M1 13h15"
            />
          </svg>
        </button>
      </div>
      <div
        id="navbar-user"
        class="items-center justify-between hidden w-full md:flex md:w-auto md:order-1"
      >
        <ul
          class="flex flex-col font-medium p-4 md:p-0 mt-4 border border-gray-100 rounded-lg bg-gray-50 md:space-x-8 rtl:space-x-reverse md:flex-row md:mt-0 md:border-0 md:bg-white dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700"
        >
          <li>
            <a
              href="#"
              class="block py-2 px-3 rounded"
              :class="{
                'text-white bg-blue-700 md:bg-transparent md:text-blue-700 md:p-0 md:dark:text-blue-500':
                  isActive('home'),
                'text-gray-900 hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-gray-700':
                  !isActive('home'),
              }"
              aria-current="page"
              @click.prevent="navigateTo('home')"
            >Accueil</a>
          </li>
          <li>
            <a
              href="#"
              class="block py-2 px-3 rounded"
              :class="{
                'text-white bg-blue-700 md:bg-transparent md:text-blue-700 md:p-0 md:dark:text-blue-500':
                  isActive('times'),
                'text-gray-900 hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent dark:border-gray-700':
                  !isActive('times'),
              }"
              @click.prevent="navigateTo('times')"
            >Mes temps</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script lang="ts">
import {
  defineComponent,
  ref,
  onMounted,
  onBeforeUnmount,
  computed,
  getCurrentInstance,
} from 'vue';
import { useRouter } from 'vue-router';
import { useAuthenticateStore } from '../../app/store/store';

export default defineComponent({
  name: 'NavBarComponent',
  setup() {
    const store = useAuthenticateStore();
    const isDropdownOpen = ref(false);
    const instance = getCurrentInstance();
    const router = useRouter();

    const toggleUserDropdown = (e: MouseEvent) => {
      e.stopPropagation();
      isDropdownOpen.value = !isDropdownOpen.value;
    };

    const closeDropdown = () => {
      isDropdownOpen.value = false;
    };

    const navigateTo = async (page: string) => {
      if (page === 'home') {
        const userId = store.user?.id;
        if (userId) {
          await router.push(`/users/${userId}`);
        } else {
          console.log('User ID not found, redirecting to login');
          await router.push('/login');
        }
      } else if (page === 'times') {
        await router.push('/times');
      }
    };

    const isActive = (page: string) => {
      const currentPath = window.location.pathname;
      return (
        (page === 'home' && currentPath === '/') ||
        (page === 'times' && currentPath === '/times')
      );
    };

    const goToSettings = () => {
      console.log('Navigating to Settings');
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
      navigateTo,
      isActive,
      goToSettings,
      logout,
      stopPropagation,
      user,
    };
  },
});
</script>

<style scoped>
.dropdown-menu {
  display: none;
}
</style>
