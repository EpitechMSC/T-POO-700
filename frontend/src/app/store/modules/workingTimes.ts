// src/stores/workingTimesStore.ts
import { defineStore } from 'pinia';
import { WorkingTime } from '../../models/workingTime';
import agent from '../../api/agent';

interface WorkingTimesState {
  workingTimes: WorkingTime[];
  currentWorkingTime: WorkingTime | null;
  loading: boolean;
  error: string | null;
}

export const useWorkingTimesStore = defineStore('workingTimes', {
  state: (): WorkingTimesState => ({
    workingTimes: [],
    currentWorkingTime: null,
    loading: false,
    error: null,
  }),
  getters: {
    workingTimeCount: state => state.workingTimes.length,
    getWorkingTimeById: state => (id: number) =>
      state.workingTimes.find(wt => wt.id === id),
  },
  actions: {
    async fetchWorkingTimes(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.WorkingTimes.list();
        this.workingTimes = response.data;
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la récupération des temps de travail';
      } finally {
        this.loading = false;
      }
    },

    async createWorkingTime(workingTime: WorkingTime): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.WorkingTimes.create(workingTime);
        this.workingTimes.push(response.data);
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
        const response = await agent.WorkingTimes.update(id, workingTime);
        const index = this.workingTimes.findIndex(wt => wt.id === id);
        if (index !== -1) {
          this.workingTimes[index] = response.data;
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

    async getUserWorkingTime(userID: string, id: string): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.WorkingTimes.getUserWorkingTime(
          userID,
          id
        );
        this.currentWorkingTime = response.data;
      } catch (err: any) {
        this.error =
          err.message ||
          "Erreur lors de la récupération du temps de travail de l'utilisateur";
      } finally {
        this.loading = false;
      }
    },
  },
});
