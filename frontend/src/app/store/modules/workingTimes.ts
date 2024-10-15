import { defineStore } from 'pinia';
import { WorkingTime, WorkingTimeStats } from '../../models/workingTime';
import agent from '../../api/agent';
import {
  Pagination,
  PagingParams,
  PaginatedResult,
} from '../../models/pagination';

interface WorkingTimesState {
  workingTimes: WorkingTime[];
  currentWorkingTime: WorkingTime | null;
  workingTimesForList: WorkingTime[];
  stats: WorkingTimeStats | null;
  loading: boolean;
  error: string | null;
  pagination: Pagination | null;
  pagingParams: PagingParams;
}

export const useWorkingTimesStore = defineStore('workingTimes', {
  state: (): WorkingTimesState => ({
    workingTimes: [],
    workingTimesForList: [],
    currentWorkingTime: null,
    loading: false,
    error: null,
    stats: null,
    pagination: null,
    pagingParams: new PagingParams(),
  }),
  getters: {
    workingTimeCount: (state): number => state.workingTimes.length,
    getWorkingTimeById: state => (id: number) =>
      state.workingTimes.find(wt => wt.id === id) || null,
  },
  actions: {
    toURLSearchParams(params: PagingParams): URLSearchParams {
      const urlParams = new URLSearchParams();
      urlParams.append('page', params.pageNumber.toString());
      urlParams.append('pageSize', params.pageSize.toString());
      return urlParams;
    },

    async fetchWorkingTimes(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = this.toURLSearchParams(this.pagingParams);
        const response: PaginatedResult<WorkingTime[]> =
          await agent.WorkingTimes.list(params);
        this.workingTimesForList = response.data;
        this.pagination = response.pagination;
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la récupération des temps de travail';
      } finally {
        this.loading = false;
      }
    },

    async fetchWorkingTimesByUserId(
      userId: number,
      page: number,
      pageSize: number
    ): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = new URLSearchParams();
        params.append('page', page.toString());
        params.append('pageSize', pageSize.toString());

        const response: PaginatedResult<WorkingTime[]> =
          await agent.WorkingTimes.getUserWorkingTimesByUserId(userId, params);

        this.workingTimesForList = response.data;
        this.pagination = response.pagination;
      } catch (err: any) {
        this.error =
          err.message ||
          `Erreur lors de la récupération des temps de travail pour l'utilisateur ${userId}`;
      } finally {
        this.loading = false;
      }
    },

    async fetchWeeklyWorkingTimes(userId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime[] =
          await agent.WorkingTimes.getUserWeeklyWorkingTimes(userId);
        this.workingTimes = response;
      } catch (err: any) {
        this.error =
          err.message ||
          'Erreur lors de la récupération des temps de travail hebdomadaires';
      } finally {
        this.loading = false;
      }
    },

    async fetchMonthlyWorkingTimes(userId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime[] =
          await agent.WorkingTimes.getUserMonthlyWorkingTimes(userId);
        this.workingTimes = response;
      } catch (err: any) {
        this.error =
          err.message ||
          'Erreur lors de la récupération des temps de travail mensuels';
      } finally {
        this.loading = false;
      }
    },

    async fetchYearlyWorkingTimes(userId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime[] =
          await agent.WorkingTimes.getUserYearlyWorkingTimes(userId);
        this.workingTimes = response;
      } catch (err: any) {
        this.error =
          err.message ||
          'Erreur lors de la récupération des temps de travail annuels';
      } finally {
        this.loading = false;
      }
    },

    async fetchWorkingTimeStats(userId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTimeStats =
          await agent.WorkingTimes.getUserWorkingTimeStats(userId);
        this.stats = response;
      } catch (err: any) {
        this.error =
          err.message ||
          `Erreur lors de la récupération des statistiques de l'utilisateur ${userId}`;
      } finally {
        this.loading = false;
      }
    },

    async createWorkingTime(workingTime: WorkingTime): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime =
          await agent.WorkingTimes.create(workingTime);
        this.workingTimes.push(response);
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la création du temps de travail';
      } finally {
        this.loading = false;
      }
    },

    async updateWorkingTime(
      id: number,
      workingTime: WorkingTime
    ): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime = await agent.WorkingTimes.update(
          id,
          workingTime
        );
        const index = this.workingTimes.findIndex(wt => wt.id === id);
        if (index !== -1) {
          this.workingTimes[index] = response;
        }
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la mise à jour du temps de travail';
      } finally {
        this.loading = false;
      }
    },

    async deleteWorkingTime(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        await agent.WorkingTimes.remove(id);
        this.workingTimes = this.workingTimes.filter(wt => wt.id !== id);
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la suppression du temps de travail';
      } finally {
        this.loading = false;
      }
    },

    async getUserWorkingTime(userID: number, id: string): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: WorkingTime =
          await agent.WorkingTimes.getUserWorkingTime(userID, id);
        this.currentWorkingTime = response;
      } catch (err: any) {
        this.error =
          err.message ||
          "Erreur lors de la récupération du temps de travail de l'utilisateur";
      } finally {
        this.loading = false;
      }
    },

    setPage(page: number): void {
      this.pagingParams.pageNumber = page;
      this.fetchWorkingTimes();
    },

    setPageSize(pageSize: number): void {
      this.pagingParams.pageSize = pageSize;
      this.fetchWorkingTimes();
    },
  },
});
