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
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="size-6"
            >
              <path
                d="M6 12a.75.75 0 0 1-.75-.75v-7.5a.75.75 0 1 1 1.5 0v7.5A.75.75 0 0 1 6 12ZM18 12a.75.75 0 0 1-.75-.75v-7.5a.75.75 0 0 1 1.5 0v7.5A.75.75 0 0 1 18 12ZM6.75 20.25v-1.5a.75.75 0 0 0-1.5 0v1.5a.75.75 0 0 0 1.5 0ZM18.75 18.75v1.5a.75.75 0 0 1-1.5 0v-1.5a.75.75 0 0 1 1.5 0ZM12.75 5.25v-1.5a.75.75 0 0 0-1.5 0v1.5a.75.75 0 0 0 1.5 0ZM12 21a.75.75 0 0 1-.75-.75v-7.5a.75.75 0 0 1 1.5 0v7.5A.75.75 0 0 1 12 21ZM3.75 15a2.25 2.25 0 1 0 4.5 0 2.25 2.25 0 0 0-4.5 0ZM12 11.25a2.25 2.25 0 1 1 0-4.5 2.25 2.25 0 0 1 0 4.5ZM15.75 15a2.25 2.25 0 1 0 4.5 0 2.25 2.25 0 0 0-4.5 0Z"
              />
            </svg>
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
            <div v-if="isEditing(rowIndex)">
              <input
                v-if="header !== 'id'"
                v-model="editedData[rowIndex][header]"
                class="w-full px-2 py-1 border border-gray-300 rounded"
              />
              <div v-else>
                {{ item[header] }}
              </div>
            </div>
            <div v-else>
              <slot name="customCell" :item="item" :field="header">
                <slot name="customCell" :item="item" :field="header">
                  {{ formatValue(item[header]) }}
                </slot>
              </slot>
            </div>
          </td>
          <td class="px-4 py-3">
            <div class="relative">
              <button
                v-if="!isEditing(rowIndex)"
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
              <div v-if="isEditing(rowIndex)" class="flex space-x-2">
                <button
                  class="text-green-600 hover:text-green-800"
                  @click="saveEdit(rowIndex)"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                    class="size-4"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M19.916 4.626a.75.75 0 0 1 .208 1.04l-9 13.5a.75.75 0 0 1-1.154.114l-6-6a.75.75 0 0 1 1.06-1.06l5.353 5.353 8.493-12.74a.75.75 0 0 1 1.04-.207Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </button>
                <button
                  class="text-red-600 hover:text-red-800"
                  @click="cancelEdit(rowIndex)"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                    class="size-4"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M16.5 4.478v.227a48.816 48.816 0 0 1 3.878.512.75.75 0 1 1-.256 1.478l-.209-.035-1.005 13.07a3 3 0 0 1-2.991 2.77H8.084a3 3 0 0 1-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 0 1-.256-1.478A48.567 48.567 0 0 1 7.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 0 1 3.369 0c1.603.051 2.815 1.387 2.815 2.951Zm-6.136-1.452a51.196 51.196 0 0 1 3.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 0 0-6 0v-.113c0-.794.609-1.428 1.364-1.452Zm-.355 5.945a.75.75 0 1 0-1.5.058l.347 9a.75.75 0 1 0 1.499-.058l-.346-9Zm5.48.058a.75.75 0 1 0-1.498-.058l-.347 9a.75.75 0 0 0 1.5.058l.345-9Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </button>
              </div>
              <div
                v-if="isMenuOpen(rowIndex)"
                class="absolute right-0 mt-2 w-32 bg-white border border-gray-200 shadow-md rounded-md z-10"
              >
                <ul>
                  <li
                    class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
                    @click="startEditing(rowIndex, item)"
                  >
                    Modifier
                  </li>
                  <li
                    class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
                    @click="deleteRow(rowIndex)"
                  >
                    Supprimer
                  </li>
                </ul>
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
        @click="currentPage--"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
      >
        Précédent
      </button>
      <span>Page {{ currentPage }} sur {{ totalPages }}</span>
      <button
        :disabled="currentPage === totalPages"
        @click="currentPage++"
        class="px-3 py-1 bg-gray-200 text-gray-600 rounded disabled:opacity-50"
      >
        Suivant
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    headers: Array,
    data: Array,
    itemsPerPage: {
      type: Number,
      default: 5,
    },
  },
  data() {
    return {
      currentPage: 1,
      editedData: [],
      isEditingRow: null,
      menuOpen: -1,
    };
  },
  computed: {
    totalPages() {
      return Math.ceil(this.data.length / this.itemsPerPage);
    },
    paginatedData() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      return this.data.slice(startIndex, startIndex + this.itemsPerPage);
    },
  },
  methods: {
    toggleMenu(index) {
      this.menuOpen = this.menuOpen === index ? -1 : index;
    },
    isMenuOpen(index) {
      return this.menuOpen === index;
    },
    formatValue(value) {
      return value || '-';
    },
    isEditing(index) {
      return this.isEditingRow === index;
    },
    startEditing(index, item) {
      this.isEditingRow = index;
      this.editedData = JSON.parse(JSON.stringify(this.paginatedData)); // Deep copy of data
    },
    saveEdit(index) {
      this.isEditingRow = null;
      this.$emit('save', this.editedData[index]);
    },
    cancelEdit() {
      this.isEditingRow = null;
      this.editedData = [];
    },
    deleteRow(index) {
      this.$emit('delete', this.paginatedData[index]);
    },
  },
};
</script>

<style scoped></style>
