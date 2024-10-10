<template>
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
        <!--  Options column -->
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
        v-for="(item, rowIndex) in data"
        :key="rowIndex"
        class="border-b border-gray-200"
      >
        <td
          v-for="(header, colIndex) in headers"
          :key="colIndex"
          class="px-4 py-3"
        >
          <!-- Check if editing-->
          <div v-if="isEditing(rowIndex)">
            <!-- Only allow input for non-id columns -->
            <input
              v-if="header !== 'id'"
              v-model="editedData[rowIndex][header]"
              class="w-full px-2 py-1 border border-gray-300 rounded"
            />
            <!-- Display value without input for id -->
            <div v-else>
              {{ item[header] }}
            </div>
          </div>
          <div v-else>
            <slot name="customCell" :item="item" :field="header">
              {{ formatValue(item[header]) }}
            </slot>
          </div>
        </td>
        <!-- Options cell -->
        <td class="px-4 py-3">
          <div class="relative">
            <button
              v-if="!isEditing(rowIndex)"
              @click="toggleMenu(rowIndex)"
              class="text-gray-500 hover:text-gray-700"
            >
              <!-- Option Icon -->
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
              <!-- validation and canceled buttons -->
              <button
                @click="saveEdit(rowIndex, item)"
                class="text-green-600 hover:text-green-800"
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
                @click="cancelEdit(rowIndex)"
                class="text-red-600 hover:text-red-800"
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

            <!-- Popup  -->
            <div
              v-if="isMenuOpen(rowIndex)"
              class="absolute right-0 mt-2 w-32 bg-white border border-gray-200 shadow-md rounded-md z-10"
            >
              <ul>
                <li
                  @click="startEditing(rowIndex, item)"
                  class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
                >
                  Modifier
                </li>
                <li
                  @click="deleteItem(item)"
                  class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
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
</template>

<script>
export default {
  name: 'TableComponent',
  props: {
    data: {
      required: true,
      type: Array,
    },
  },
  data() {
    return {
      menuOpenIndex: null,
      editingIndex: null,
      editedData: {},
    };
  },
  computed: {
    headers() {
      return this.data.length ? Object.keys(this.data[0]) : [];
    },
  },
  methods: {
    formatValue(value) {
      const date = new Date(value);
      if (
        !isNaN(date.getTime()) &&
        typeof value === 'string' &&
        !value.match(/^\d+$/)
      ) {
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`; // Format: dd/MM/yyyy
      }
      return value;
    },
    toggleMenu(index) {
      this.menuOpenIndex = this.menuOpenIndex === index ? null : index;
    },
    isMenuOpen(index) {
      return this.menuOpenIndex === index;
    },
    startEditing(rowIndex, item) {
      this.editingIndex = rowIndex;
      this.editedData[rowIndex] = { ...item };
      this.menuOpenIndex = null;
    },
    isEditing(rowIndex) {
      return this.editingIndex === rowIndex;
    },
    cancelEdit(rowIndex) {
      this.editingIndex = null;
      this.editedData[rowIndex] = null;
    },
    async saveEdit(rowIndex, item) {
      const updatedItem = this.editedData[rowIndex];
      this.$emit('save-edit', updatedItem);
      this.editingIndex = null;
      this.editedData[rowIndex] = null;
    },
    deleteItem(item) {
      this.$emit('delete-item', item);
      this.menuOpenIndex = null;
    },
  },
};
</script>

<style scoped></style>
