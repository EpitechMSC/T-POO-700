import { defineStore } from 'pinia';
import { User } from '../../models/user';
import Authenticate from '../../api/modules/authenticate';
import router from '../../router/router';

interface AuthenticateState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
}

export const useAuthenticateStore = defineStore('authenticate', {
  state: (): AuthenticateState => ({
    user: null,
    token: localStorage.getItem('token') || null,
    isAuthenticated: !!localStorage.getItem('token'),
  }),

  getters: {
    getUser: state => state.user,
  },

  actions: {
    setToken(token: string | null) {
      this.token = token;
      if (token) {
        localStorage.setItem('token', token);
      } else {
        localStorage.removeItem('token');
      }
    },

    async login(email: string): Promise<number> {
      try {
        const response = await Authenticate.userByEmail(email);
        this.setToken(response.token);
        this.isAuthenticated = true;

        await this.fetchUser();

        if (this.user) {
          return this.user.id;
        } else {
          throw new Error('User not found after login');
        }
      } catch (error) {
        console.error('Login failed:', error);
        throw new Error('Login failed');
      }
    },

    logout() {
      this.setToken(null);
      this.user = null;
      this.isAuthenticated = false;
      router.push('/login');
    },

    async fetchUser() {
      try {
        const user = await Authenticate.userDetails();
        this.user = user;
      } catch (error) {
        console.error('Failed to fetch user:', error);
        this.logout();
        throw new Error('Failed to fetch user');
      }
    },
  },
});
