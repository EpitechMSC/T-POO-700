import { defineStore } from 'pinia';
import { Clock } from '../../models/clock';
import agent from '../../api/agent';
import {
  Pagination,
  PagingParams,
  PaginatedResult,
} from '../../models/pagination';

interface ClocksState {
  clocks: Clock[];
  loading: boolean;
  error: string | null;
  pagination: Pagination | null;
  pagingParams: PagingParams;
  clockIn: string | null;
  lastClock: Clock | null;
}

export const useClocksStore = defineStore('clocks', {
  state: (): ClocksState => ({
    clocks: [],
    loading: false,
    error: null,
    pagination: null,
    pagingParams: new PagingParams(),
    clockIn: null,
    lastClock: null,
  }),
  getters: {
    clockCount: state => state.clocks.length,
  },
  actions: {
    async fetchClocks(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = new URLSearchParams();
        params.append('page', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        const response: PaginatedResult<Clock[]> =
          await agent.Clocks.list(params);
        this.clocks = response.data;
        this.pagination = response.pagination;
        console.log('hola', params);

        this.lastClock = response.data[-1];
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || 'Erreur lors de la récupération des horloges';
        } else {
          this.error = 'Erreur inconnue lors de la récupération des horloges';
        }
      } finally {
        this.loading = false;
      }
    },

    async createClock(clock: Clock): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Clocks.create(clock);
        this.clocks.push(response);
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error = err.message || "Erreur lors de la création de l'horloge";
        } else {
          this.error = "Erreur inconnue lors de la création de l'horloge";
        }
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
          this.clocks[index] = response;
        }
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la mise à jour de l'horloge";
        } else {
          this.error = "Erreur inconnue lors de la mise à jour de l'horloge";
        }
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
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la suppression de l'horloge";
        } else {
          this.error = "Erreur inconnue lors de la suppression de l'horloge";
        }
      } finally {
        this.loading = false;
      }
    },
    setClockIn(time: string | null): void {
      this.clockIn = time;
    },
    getClockIn(): string | null {
      return this.clockIn;
    },
    async fetchLastClockOfUser(id: number): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        const response = await agent.Clocks.getLastByUserId(id);
        this.lastClock = response;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message ||
            'Erreur lors de la récupération de la derniere horloge';
        } else {
          this.error = 'Erreur lors de la récupération de la derniere horloge';
        }
      } finally {
        this.loading = false;
      }
    },
  },
});
