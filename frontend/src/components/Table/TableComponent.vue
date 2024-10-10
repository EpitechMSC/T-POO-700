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
          <slot name="customCell" :item="item" :field="header">
            {{ formatValue(item[header]) }}
          </slot>
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
  },
};
</script>

<style scoped></style>
