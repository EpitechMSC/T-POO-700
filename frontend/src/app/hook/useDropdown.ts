import { ref, onMounted, onBeforeUnmount, getCurrentInstance } from 'vue';

export function useDropdown() {
  const isDropdownOpen = ref(false);
  const instance = getCurrentInstance();

  const toggleDropdown = (e: MouseEvent) => {
    e.stopPropagation();
    isDropdownOpen.value = !isDropdownOpen.value;
  };

  const closeDropdown = () => {
    isDropdownOpen.value = false;
  };

  const stopPropagation = (e: MouseEvent) => {
    e.stopPropagation();
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

  return {
    isDropdownOpen,
    toggleDropdown,
    closeDropdown,
    stopPropagation,
  };
}
