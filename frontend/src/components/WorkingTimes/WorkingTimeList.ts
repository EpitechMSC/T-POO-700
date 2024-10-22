import { defineComponent, computed, ref, watch } from 'vue';
import TableComponent from '../Table/TableComponent.vue';
import { useWorkingTimesStore } from '../../app/store/store';
import { useAuthenticateStore } from '../../app/store/store';
import { WorkingTime } from '../../app/models/workingTime';
import { useDropdown } from '../../app/hook/useDropdown';
import ModalComponent from '../Modal/ModalComponent.vue';

export default defineComponent({
  name: 'WorkingTimeList',
  components: {
    TableComponent,
    ModalComponent,
  },
  setup() {
    const workingTimesStore = useWorkingTimesStore();
    const authStore = useAuthenticateStore();

    const { isDropdownOpen, toggleDropdown, stopPropagation } = useDropdown();

    const showUpdateModal = ref(false);
    const showDeleteConfirm = ref(false);
    const updateForm = ref<{ start: string; end: string }>({
      start: '',
      end: '',
    });
    const currentWorkingTimeId = ref<number | null>(null);
    const itemToDelete = ref<WorkingTime | null>(null);

    const loadWorkingTimes = () => {
      const userId = authStore.user?.id;
      if (userId) {
        workingTimesStore.fetchWorkingTimesByUserId(
          userId,
          workingTimesStore.pagingParams.pageNumber,
          workingTimesStore.pagingParams.pageSize
        );
      }
    };

    watch(
      () => authStore.user,
      newUser => {
        if (newUser?.id) {
          loadWorkingTimes();
        }
      },
      { immediate: true }
    );

    watch(
      () => workingTimesStore.pagingParams.pageNumber,
      () => {
        const userId = authStore.user?.id;
        if (userId) {
          loadWorkingTimes();
        }
      }
    );

    const workingTimes = computed(() => workingTimesStore.workingTimesForList);
    const loading = computed(() => workingTimesStore.loading);
    const error = computed(() => workingTimesStore.error);
    const pagingParams = computed(() => workingTimesStore.pagingParams);
    const totalPages = computed(
      () => workingTimesStore.pagination?.total_pages || 0
    );

    const changePage = async (newPage: number) => {
      const userId = authStore.user?.id;
      if (newPage >= 1 && userId) {
        await workingTimesStore.setPage(
          workingTimesStore.fetchWorkingTimesByUserId,
          userId,
          newPage
        );
      }
    };

    const formatDay = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR');
    };

    const formatTime = (dateString: string) => {
      const date = new Date(dateString);
      return date.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit',
      });
    };

    const confirmDelete = (item: WorkingTime) => {
      itemToDelete.value = item;
      showDeleteConfirm.value = true;
    };

    const closeDeleteConfirm = () => {
      showDeleteConfirm.value = false;
      itemToDelete.value = null;
    };

    const deleteWorkingTime = async () => {
      if (itemToDelete.value) {
        await workingTimesStore.deleteWorkingTime(itemToDelete.value.id);
        closeDeleteConfirm();
        loadWorkingTimes();
      }
    };

    const openUpdateModal = (item: WorkingTime) => {
      updateForm.value.start = item.start;
      updateForm.value.end = item.end;
      currentWorkingTimeId.value = item.id;
      showUpdateModal.value = true;
    };

    const closeUpdateModal = () => {
      showUpdateModal.value = false;
      updateForm.value = { start: '', end: '' };
      currentWorkingTimeId.value = null;
    };

    const updateWorkingTime = async () => {
      if (currentWorkingTimeId.value) {
        const updatedTime = {
          start: updateForm.value.start,
          end: updateForm.value.end,
        };
        await workingTimesStore.updateWorkingTime(
          currentWorkingTimeId.value,
          updatedTime as WorkingTime
        );
        closeUpdateModal();
        loadWorkingTimes();
      }
    };

    return {
      workingTimes,
      loading,
      error,
      changePage,
      pagingParams,
      totalPages,
      showUpdateModal,
      showDeleteConfirm,
      updateForm,
      currentWorkingTimeId,
      itemToDelete,
      loadWorkingTimes,
      openUpdateModal,
      confirmDelete,
      deleteWorkingTime,
      closeDeleteConfirm,
      closeUpdateModal,
      updateWorkingTime,
      formatDay,
      formatTime,
      // Dropdown related
      isDropdownOpen,
      toggleDropdown,
      stopPropagation,
    };
  },
});
