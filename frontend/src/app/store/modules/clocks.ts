import { defineStore } from 'pinia';
import { Clock } from '../../models/clock';
import agent from '../../api/agent';

interface ClocksState {
  clocks: Clock[];
  loading: boolean;
  error: string | null;
}

export const useClocksStore = defineStore('clocks', {
  state: (): ClocksState => ({
    clocks: [],
    loading: false,
    error: null,
  }),
  getters: {
    clockCount: state => state.clocks.length,
  },
  actions: {
    async fetchClocks(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Clocks.list();
        this.clocks = response.data;
      } catch (err: any) {
        this.error =
          err.message || 'Erreur lors de la récupération des horloges';
      } finally {
        this.loading = false;
      }
    },

    async createClock(clock: Clock): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Clocks.create(clock);
        this.clocks.push(response.data);
      } catch (err: any) {
        this.error = err.message || "Erreur lors de la création de l'horloge";
      } finally {
        this.loading = false;
      }
    },

    async updateClock(id: number, clock: Clock): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Clocks.update(id, clock);
        const index = this.clocks.findIndex(c => c.id === id);
        if (index !== -1) {
          this.clocks[index] = response.data;
        }
      } catch (err: any) {
        this.error =
          err.message || "Erreur lors de la mise à jour de l'horloge";
      } finally {
        this.loading = false;
      }
    },

    async deleteClock(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        await agent.Clocks.remove(id);
        this.clocks = this.clocks.filter(c => c.id !== id);
      } catch (err: any) {
        this.error =
          err.message || "Erreur lors de la suppression de l'horloge";
      } finally {
        this.loading = false;
      }
    },
  },
});
