// src/stores/rolesStore.ts

import { defineStore } from 'pinia';
import { Role } from '../../models/role';
import agent from '../../api/agent';
import {
  Pagination,
  PagingParams,
  PaginatedResult,
} from '../../models/pagination';

interface RolesState {
  roles: Role[];
  currentRole: Role | null;
  loading: boolean;
  error: string | null;
  pagination: Pagination | null;
  pagingParams: PagingParams;
}

export const useRolesStore = defineStore('roles', {
  state: (): RolesState => ({
    roles: [],
    currentRole: null,
    loading: false,
    error: null,
    pagination: null,
    pagingParams: new PagingParams(),
  }),
  getters: {
    roleCount: state => state.roles.length,
  },
  actions: {
    async fetchRoles(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const params = new URLSearchParams();
        params.append('page', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        const response: PaginatedResult<Role[]> =
          await agent.Roles.list(params);
        this.$patch({
          roles: response.data,
          pagination: response.pagination,
        });
      } catch (err: unknown) {
        this.$patch({
          error:
            err instanceof Error
              ? err.message
              : 'Erreur lors de la récupération des rôles',
        });
      } finally {
        this.loading = false;
      }
    },

    async createRole(role: Role): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        const response = await agent.Roles.create(role);
        this.$patch({
          roles: [...this.roles, response],
        });
      } catch (err: unknown) {
        this.$patch({
          error:
            err instanceof Error
              ? err.message
              : 'Erreur lors de la création du rôle',
        });
      } finally {
        this.loading = false;
      }
    },

    async getRoleDetails(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Roles.details(id);
        this.$patch({
          currentRole: response,
        });
      } catch (err: unknown) {
        this.$patch({
          error:
            err instanceof Error
              ? err.message
              : 'Erreur lors de la récupération du rôle',
        });
      } finally {
        this.loading = false;
      }
    },

    async updateRole(id: number, role: Role): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Roles.update(id, role);
        const index = this.roles.findIndex(r => r.id === id);
        if (index !== -1) {
          this.$patch({
            roles: this.roles.map(r => (r.id === id ? response : r)),
          });
        }
      } catch (err: unknown) {
        this.$patch({
          error:
            err instanceof Error
              ? err.message
              : 'Erreur lors de la mise à jour du rôle',
        });
      } finally {
        this.loading = false;
      }
    },

    async deleteRole(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        await agent.Roles.remove(id);
        this.$patch({
          roles: this.roles.filter(r => r.id !== id),
        });
      } catch (err: unknown) {
        this.$patch({
          error:
            err instanceof Error
              ? err.message
              : 'Erreur lors de la suppression du rôle',
        });
      } finally {
        this.loading = false;
      }
    },

    setPage(page: number): void {
      this.pagingParams.pageNumber = page;
      this.fetchRoles();
    },

    setPageSize(pageSize: number): void {
      this.pagingParams.pageSize = pageSize;
      this.fetchRoles();
    },
  },
});
