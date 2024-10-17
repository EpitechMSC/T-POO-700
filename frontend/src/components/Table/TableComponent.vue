<template>
  <div>
    <table class="min-w-full table-auto border-collapse">
      <thead class="bg-gray-100">
        <tr class="border-b border-gray-200">
          <th
            v-for="(header, index) in headers"
            :key="index"
            class="px-4 py-2 text-left text-sm font-semibold text-gray-600"
          >
            {{ header }}
          </th>
          <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600">
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
                {{ formatValue(item[header]) }}
              </slot>
            </slot>
          </td>

          <!-- Options Column -->
          <td class="px-4 py-3">
            <div class="relative">
              <button
                class="text-gray-500 hover:text-gray-700"
                @click="toggleMenu(rowIndex)"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6"
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
              >
                <button
                  class="block px-4 py-2 text-red-500 hover:bg-gray-100"
                  @click="confirmDelete(rowIndex)"
                >
                  Supprimer
                </button>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Pagination Controls -->
    <div class="flex justify-end mt-4 space-x-2">
      <button
        :disabled="currentPage === 1"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="currentPage--"
      >
        Précédent
      </button>
      <span>Page {{ currentPage }} sur {{ totalPages }}</span>
      <button
        :disabled="currentPage === totalPages"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
        @click="currentPage++"
      >
        Suivant
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';

export default defineComponent({
  name: 'TableComponent',
  props: {
    headers: {
      type: Array as PropType<string[]>,
      required: true,
    },
    data: {
      type: Array as PropType<any[]>,
      required: true,
    },
    itemsPerPage: {
      type: Number,
      default: 5,
    },
  },
  emits: ['delete-item'],
  data() {
    return {
      currentPage: 1,
      activeRow: null as number | null,
    };
  },
  computed: {
    totalPages(): number {
      return Math.ceil(this.data.length / this.itemsPerPage);
    },
    paginatedData(): any[] {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      return this.data.slice(startIndex, startIndex + this.itemsPerPage);
    },
  },
  methods: {
    toggleMenu(rowIndex: number): void {
      this.activeRow = this.activeRow === rowIndex ? null : rowIndex;
    },
    confirmDelete(rowIndex: number): void {
      this.$emit('delete-item', this.data[rowIndex]);
      this.activeRow = null;
    },
    formatValue(value: string | number): string {
      const date = new Date(value as string);
      return !isNaN(date.getTime())
        ? date.toLocaleString('fr-FR')
        : String(value);
    },
  },
});
</script>
