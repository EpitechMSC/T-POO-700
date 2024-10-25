import { defineComponent, ref, computed, watch } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import ModalComponent from '../Modal/ModalComponent.vue';
import { useAuthenticateStore, useUsersStore } from '../../app/store/store';
import { User } from '../../app/models/user';

export default defineComponent({
  name: 'UsersList',
  components: { TableComponent, ModalComponent },
  setup() {
    const usersStore = useUsersStore();
    const authStore = useAuthenticateStore();

    const showUpdateModal = ref(false);
    const showDeleteConfirm = ref(false);
    const updateForm = ref({ username: '', email: '', role: 0 });
    const currentUserId = ref<number | null>(null);
    const userToDelete = ref<User | null>(null);

    const loadUsers = () => {
      usersStore.fetchAllUsers();
    };

    const users = computed(() => usersStore.users);
    const loading = computed(() => usersStore.loading);
    const error = computed(() => usersStore.error);
    const pagingParams = computed(() => usersStore.pagingParams);
    const totalPages = computed(() => usersStore.pagination?.total_pages || 0);

    const changePage = (newPage: number) => {
      if (newPage >= 1) {
        usersStore.setPage(newPage);
      }
    };

    const openUpdateModal = (user: User) => {
      updateForm.value = {
        username: user.username,
        email: user.email,
        role: user.role,
      };
      currentUserId.value = user.id;
      showUpdateModal.value = true;
    };

    const closeUpdateModal = () => {
      showUpdateModal.value = false;
      updateForm.value = { username: '', email: '', role: 0 };
      currentUserId.value = null;
    };

    const updateUser = async () => {
      if (currentUserId.value) {
        await usersStore.updateUser(
          currentUserId.value,
          updateForm.value as User
        );
        closeUpdateModal();
        loadUsers();
      }
    };

    const confirmDelete = (user: User) => {
      userToDelete.value = user;
      showDeleteConfirm.value = true;
    };

    const closeDeleteConfirm = () => {
      showDeleteConfirm.value = false;
      userToDelete.value = null;
    };

    const deleteUser = async () => {
      if (userToDelete.value) {
        await usersStore.deleteUser(userToDelete.value.id);
        closeDeleteConfirm();
        loadUsers();
      }
    };

    watch(() => authStore.user, loadUsers, { immediate: true });

    return {
      users,
      loading,
      error,
      changePage,
      pagingParams,
      totalPages,
      showUpdateModal,
      showDeleteConfirm,
      updateForm,
      openUpdateModal,
      confirmDelete,
      deleteUser,
      closeDeleteConfirm,
      closeUpdateModal,
      updateUser,
    };
  },
});
