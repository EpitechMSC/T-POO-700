import { defineStore } from 'pinia';
import { Event } from '../../models/event';
import agent from '../../api/agent';
import {
  Pagination,
  PagingParams,
  PaginatedResult,
} from '../../models/pagination';
import { useTeamStore, useAuthenticateStore } from '../store';

interface EventsState {
  events: Event[];
  loading: boolean;
  error: string | null;
  pagination: Pagination | null;
  pagingParams: PagingParams;
}

export const useEventsStore = defineStore('events', {
  state: (): EventsState => ({
    events: [],
    loading: false,
    error: null,
    pagination: null,
    pagingParams: new PagingParams(),
  }),

  getters: {
    eventCount: state => state.events.length,
  },

  actions: {
    async fetchEvents(): Promise<void> {
      this.loading = true;
      this.error = null;
      const teamStore = useTeamStore();

      if (!teamStore.team) {
        this.error = 'Équipe non sélectionnée';
        this.loading = false;
        return;
      }

      try {
        const params = new URLSearchParams();
        params.append('page', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        const response: PaginatedResult<Event[]> = await agent.Events.list(
          teamStore.team.id,
          params
        );
        this.events = response.data;
        console.log(response);
        this.pagination = response.pagination;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || 'Erreur lors de la récupération des événements';
        } else {
          this.error = 'Erreur inconnue lors de la récupération des événements';
        }
      } finally {
        this.loading = false;
      }
    },

    async fetchUserEvents(): Promise<void> {
      this.loading = true;
      this.error = null;
      const authenticateStore = useAuthenticateStore();

      if (!authenticateStore.user) {
        this.error = 'Utilisateur non connecté';
        this.loading = false;
        return;
      }

      try {
        const response: Event[] = await agent.Events.listByUserId(
          authenticateStore.user.id
        );
        this.events = response;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message ||
            "Erreur lors de la récupération des événements de l'utilisateur";
        } else {
          this.error =
            "Erreur inconnue lors de la récupération des événements de l'utilisateur";
        }
      } finally {
        this.loading = false;
      }
    },

    async createEvent(event: Event): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        const response = await agent.Events.create(event.team_id, event);
        this.events.push(response);
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la création de l'événement";
        } else {
          this.error = "Erreur inconnue lors de la création de l'événement";
        }
      } finally {
        this.loading = false;
      }
    },

    async updateEvent(id: number, event: Event): Promise<void> {
      this.loading = true;
      this.error = null;
      const teamStore = useTeamStore();

      if (!teamStore.team) {
        this.error = 'Équipe non sélectionnée';
        this.loading = false;
        return;
      }

      try {
        const response = await agent.Events.update(
          teamStore.team.id,
          id,
          event
        );
        const index = this.events.findIndex(e => e.id === id);
        if (index !== -1) {
          this.events[index] = response;
        }
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la mise à jour de l'événement";
        } else {
          this.error = "Erreur inconnue lors de la mise à jour de l'événement";
        }
      } finally {
        this.loading = false;
      }
    },

    async deleteEvent(id: number, team_id: number): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        await agent.Events.remove(team_id, id);
        this.events = this.events.filter(e => e.id !== id);
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la suppression de l'événement";
        } else {
          this.error = "Erreur inconnue lors de la suppression de l'événement";
        }
      } finally {
        this.loading = false;
      }
    },

    setPage(page: number): void {
      this.pagingParams.pageNumber = page;
      this.fetchEvents();
    },

    setPageSize(pageSize: number): void {
      this.pagingParams.pageSize = pageSize;
      this.fetchEvents();
    },
  },
});
