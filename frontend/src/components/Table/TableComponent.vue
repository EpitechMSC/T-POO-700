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
                  class="flex items-center justify-between content-center gap-1 w-full block px-4 py-2 text-blue-500 hover:bg-gray-100 text-left"
                  @click="$emit('edit-item', item)"
                >
                  Edit
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 16 16"
                    fill="currentColor"
                    class="size-4"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M11.013 2.513a1.75 1.75 0 0 1 2.475 2.474L6.226 12.25a2.751 2.751 0 0 1-.892.596l-2.047.848a.75.75 0 0 1-.98-.98l.848-2.047a2.75 2.75 0 0 1 .596-.892l7.262-7.261Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </button>
                <button
                  class="flex items-center justify-between content-center gap-1 w-full block px-4 py-2 text-red-500 hover:bg-gray-100 text-left"
                  @click="$emit('delete-item', item)"
                >
                  Delet
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 16 16"
                    fill="currentColor"
                    class="size-4"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14Zm4-7a.75.75 0 0 0-.75-.75h-6.5a.75.75 0 0 0 0 1.5h6.5A.75.75 0 0 0 12 8Z"
                      clip-rule="evenodd"
                    />
                  </svg>
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
        class="flex items-center gap-1 px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="$emit('change-page', currentPage - 1)"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 16 16"
          fill="currentColor"
          class="size-4"
        >
          <path
            fill-rule="evenodd"
            d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Zm10.25.75a.75.75 0 0 0 0-1.5H6.56l1.22-1.22a.75.75 0 0 0-1.06-1.06l-2.5 2.5a.75.75 0 0 0 0 1.06l2.5 2.5a.75.75 0 1 0 1.06-1.06L6.56 8.75h4.69Z"
            clip-rule="evenodd"
          />
        </svg>
        Previous
      </button>
      <span>Page {{ currentPage }} sur {{ totalPages }}</span>
      <button
        :disabled="currentPage === totalPages"
        class="flex items-center gap-1 px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="$emit('change-page', currentPage + 1)"
      >
        Next
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 16 16"
          fill="currentColor"
          class="size-4"
        >
          <path
            fill-rule="evenodd"
            d="M15 8A7 7 0 1 0 1 8a7 7 0 0 0 14 0ZM4.75 7.25a.75.75 0 0 0 0 1.5h4.69L8.22 9.97a.75.75 0 1 0 1.06 1.06l2.5-2.5a.75.75 0 0 0 0-1.06l-2.5-2.5a.75.75 0 0 0-1.06 1.06l1.22 1.22H4.75Z"
            clip-rule="evenodd"
          />
        </svg>
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
