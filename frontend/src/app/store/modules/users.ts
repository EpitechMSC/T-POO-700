import { defineStore } from 'pinia';
import { User } from '../../models/user';
import agent from '../../api/agent';

interface UsersState {
  users: User[];
  currentUser: User | null;
  loading: boolean;
  error: string | null;
}

export const useUsersStore = defineStore('users', {
  state: (): UsersState => ({
    users: [],
    currentUser: null,
    loading: false,
    error: null,
  }),
  getters: {
    userCount: state => state.users.length,
  },
  actions: {
    async fetchUsers(email?: string, username?: string): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await agent.Users.searchByEmailOrUsername(
          email,
          username
        );
        this.$patch({
          users: response,
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
        const response = await agent.Users.list();
        this.$patch({
          users: response,
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

    async createUser(user: User): Promise<void> {
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
            users: this.users.map(u => (u.id === id ? response : u)), // Utilisation de map pour une mise à jour immuable
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
  },
});
