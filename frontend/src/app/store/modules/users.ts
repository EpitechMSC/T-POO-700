// src/app/store/usersStore.ts

import { defineStore } from 'pinia';
import { User, UserPayload } from '../../models/user';
import agent from '../../api/agent';
import {
  Pagination,
  PagingParams,
  PaginatedResult,
} from '../../models/pagination';

interface UsersState {
  users: User[];
  currentUser: User | null;
  loading: boolean;
  error: string | null;
  userSummary: any;
  pagination: Pagination | null;
  pagingParams: PagingParams;
}

export const useUsersStore = defineStore('users', {
  state: (): UsersState => ({
    users: [],
    currentUser: null,
    loading: false,
    error: null,
    userSummary: null,
    pagination: null,
    pagingParams: new PagingParams(),
  }),
  getters: {
    userCount: state => state.users.length,
  },
  actions: {
    async fetchUsers(email?: string, username?: string): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = new URLSearchParams();
        if (email) params.append('email', email);
        if (username) params.append('username', username);
        params.append('page', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        const response: PaginatedResult<User[]> =
          await agent.Users.searchByEmailOrUsername(params);
        this.$patch({
          users: response.data,
          pagination: response.pagination,
        });
      } catch (err: any) {
        this.$patch({
          error:
            err.message || 'Erreur lors de la récupération des utilisateurs',
        });
      } finally {
        this.loading = false;
      }
    },

    async fetchAllUsers(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = new URLSearchParams();
        params.append('page', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        const response: PaginatedResult<User[]> =
          await agent.Users.list(params);
        this.$patch({
          users: response.data,
          pagination: response.pagination,
        });
      } catch (err: any) {
        this.$patch({
          error:
            err.message || 'Erreur lors de la récupération des utilisateurs',
        });
      } finally {
        this.loading = false;
      }
    },

    async createUser(user: UserPayload): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        const response = await agent.Users.create(user);
        this.$patch({
          users: [...this.users, response],
        });
      } catch (err: any) {
        this.$patch({
          error: err.message || "Erreur lors de la création de l'utilisateur",
        });
      } finally {
        this.loading = false;
      }
    },

    async getUserDetails(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Users.details(id);
        this.$patch({
          currentUser: response,
        });
      } catch (err: any) {
        this.$patch({
          error:
            err.message ||
            "Erreur lors de la récupération des détails de l'utilisateur",
        });
      } finally {
        this.loading = false;
      }
    },

    async updateUser(id: number, user: User): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Users.update(id, user);
        const index = this.users.findIndex(u => u.id === id);
        if (index !== -1) {
          this.$patch({
            users: this.users.map(u => (u.id === id ? response : u)),
          });
        }
      } catch (err: any) {
        this.$patch({
          error:
            err.message || "Erreur lors de la mise à jour de l'utilisateur",
        });
      } finally {
        this.loading = false;
      }
    },

    async deleteUser(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        await agent.Users.remove(id);
        this.$patch({
          users: this.users.filter(u => u.id !== id),
        });
      } catch (err: any) {
        this.$patch({
          error:
            err.message || "Erreur lors de la suppression de l'utilisateur",
        });
      } finally {
        this.loading = false;
      }
    },

    setPage(page: number): void {
      this.pagingParams.pageNumber = page;
      this.fetchAllUsers();
    },

    setPageSize(pageSize: number): void {
      this.pagingParams.pageSize = pageSize;
      this.fetchAllUsers();
    },
  },
});
