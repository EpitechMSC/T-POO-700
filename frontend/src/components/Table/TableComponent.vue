<template>
  <div>
    <table class="min-w-full table-auto border-collapse">
      <thead id="working-time-list-details" class="bg-gray-100">
        <tr class="border-b border-gray-200">
          <th
            v-for="(header, index) in headers"
            :key="index"
            class="px-4 py-2 text-left text-sm font-semibold text-gray-600"
          >
            {{ header }}
          </th>
          <th
            v-if="isAuthorized"
            class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-center"
          >
            Options
          </th>
        </tr>
      </thead>
      <tbody class="text-gray-600 text-sm">
        <tr
          v-for="(item, rowIndex) in paginatedData"
          :key="rowIndex"
          class="border-b border-gray-200"
        >
          <td
            v-for="(header, colIndex) in headers"
            :key="colIndex"
            class="px-4 py-3"
          >
            <slot
              :name="`cell-${header}`"
              :item="item"
              :field="header"
              :row-index="rowIndex"
            >
              <slot name="defaultCell" :item="item" :field="header">
                {{ formatValue(item[header as keyof T]) }}
              </slot>
            </slot>
          </td>

          <td v-if="isAuthorized" class="px-4 py-3">
            <div class="relative">
              <button
                class="text-gray-500 hover:text-gray-700 w-full"
                @click="e => toggleMenu(e, rowIndex)"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6 mx-auto"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 6v.01M12 12v.01M12 18v.01"
                  />
                </svg>
              </button>
              <div
                v-if="activeRow === rowIndex"
                class="absolute z-10 bg-white shadow-md p-2 rounded"
                @click.stop
                ref="dropdownMenus"
              >
                <button
                  class="w-full block px-4 py-2 text-blue-500 hover:bg-gray-100 text-left"
                  @click="$emit('edit-item', item)"
                >
                  Modifier
                </button>
                <button
                  class="w-full block px-4 py-2 text-red-500 hover:bg-gray-100 text-left"
                  @click="$emit('delete-item', item)"
                >
                  Supprimer
                </button>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="flex justify-end mt-4 space-x-2">
      <button
        :disabled="currentPage === 1"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="$emit('change-page', currentPage - 1)"
      >
        Précédent
      </button>
      <span>Page {{ currentPage }} sur {{ totalPages }}</span>
      <button
        :disabled="currentPage === totalPages"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="$emit('change-page', currentPage + 1)"
      >
        Suivant
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
import { useAuthenticateStore } from '../../app/store/store';

export default defineComponent({
  name: 'TableComponent',
  props: {
    headers: {
      type: Array as PropType<string[]>,
      required: true,
    },
    data: {
      type: Array as PropType<T[]>,
      required: true,
    },
    currentPage: {
      type: Number,
      required: true,
    },
    totalPages: {
      type: Number,
      required: true,
    },
    itemsPerPage: {
      type: Number,
      default: 5,
    },
  },
  emits: ['delete-item', 'edit-item', 'change-page'],
  data() {
    return {
      activeRow: null as number | null,
    };
  },
  computed: {
    paginatedData(): T[] {
      return this.data;
    },
    isAuthorized() {
      const authStore = useAuthenticateStore();
      const userRole = authStore.role;
      return userRole === 'Manager' || userRole === 'Supervisor';
    },
  },
  methods: {
    toggleMenu(e: MouseEvent, rowIndex: number): void {
      e.stopPropagation();
      this.activeRow = this.activeRow === rowIndex ? null : rowIndex;
    },
    formatValue(value: string | number): string {
      const date = new Date(value as string);
      return !isNaN(date.getTime())
        ? date.toLocaleString('fr-FR')
        : String(value);
    },
    handleClickOutside(event: MouseEvent) {
      const dropdownMenus = this.$refs.dropdownMenus as HTMLElement[];
      let isInsideDropdown = false;

      dropdownMenus.forEach(dropdown => {
        if (dropdown && dropdown.contains(event.target as Node)) {
          isInsideDropdown = true;
        }
      });

      if (!isInsideDropdown) {
        this.activeRow = null;
      }
    },
  },
  mounted() {
    document.addEventListener('click', this.handleClickOutside);
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside);
  },
});

type T = Record<string, string | number>;
</script>
