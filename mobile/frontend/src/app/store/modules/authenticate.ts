import { defineStore } from 'pinia';
import Authenticate from '../../api/modules/authenticate';
import router from '../../router/router';
import { AuthenticateState, Credentials } from '../../models/authentication';
import { User } from '../../models/user';

export const useAuthenticateStore = defineStore('authenticate', {
  state: (): AuthenticateState => ({
    user: null,
    token: localStorage.getItem('token') || null,
    isAuthenticated: !!localStorage.getItem('token'),
  }),

  getters: {
    getUser: (state): User | null => state.user,
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

    async login(credentials: Credentials): Promise<number> {
      try {
        const response = await Authenticate.userByEmail(credentials.email, credentials.password);
        this.setToken(response.token);
        this.isAuthenticated = true;

        await this.fetchUser();

        if (this.user) {
          return this.user.id;
        } else {
          throw new Error('Utilisateur non trouvé après connexion');
        }
      } catch (error) {
        console.error('Login failed:', error);
        throw new Error('Échec de la connexion');
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
        throw new Error(
          'Échec de la récupération des informations utilisateur'
        );
      }
    },
  },
});
