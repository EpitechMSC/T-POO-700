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
          Options
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
                ✔
              </button>
              <button
                @click="cancelEdit(rowIndex)"
                class="text-red-600 hover:text-red-800"
              >
                ✖
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
