<template>
  <TableComponent v-if="!loading && !error" :data="users" />
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue';
import { useUsersStore } from '../../app/store/store';
import TableComponent from '../Table/TableComponent.vue';

export default defineComponent({
  name: 'UserList',
  components: {
    TableComponent,
  },
  setup() {
    const usersStore = useUsersStore();

    onMounted(() => {
      usersStore.fetchAllUsers();
    });

    const deleteUser = (id: number) => {
      usersStore.deleteUser(id);
    };

    return {
      users: usersStore.users,
      loading: usersStore.loading,
      error: usersStore.error,
      deleteUser,
    };
  },
});
</script>

<style scoped></style>
