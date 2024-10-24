import { defineStore } from 'pinia';
import Authenticate from '../../api/modules/authenticate';
import { Credentials } from '../../models/authentication';
import { User } from '../../models/user';
import { jwtDecode } from 'jwt-decode';

interface AuthenticateState {
  user: User | null;
  token: string | null;
  csrf_token: string | null;
  isAuthenticated: boolean;
  role: string | null;
}

export const useAuthenticateStore = defineStore('authenticate', {
  state: (): AuthenticateState => ({
    user: null,
    token: localStorage.getItem('token') || null,
    csrf_token: localStorage.getItem('csrf_token') || null,
    isAuthenticated: !!localStorage.getItem('token'),
    role: null,
  }),

  getters: {
    getUser: (state): User | null => state.user,
    getUserRole: (state): string | null => state.role,
  },

  actions: {
    setToken(token: string | null) {
      this.token = token;
      if (token) {
        localStorage.setItem('token', token);
        const decodedToken = this.decodeToken(token);
        this.role = decodedToken?.role || null;
      } else {
        localStorage.removeItem('token');
        this.role = null;
      }
    },

    setcsrf_token(csrf_token: string | null) {
      this.csrf_token = csrf_token;
      if (csrf_token) {
        localStorage.setItem('csrf_token', csrf_token);
      } else {
        localStorage.removeItem('csrf_token');
      }
    },

    async login(credentials: Credentials): Promise<number> {
      try {
        const response = await Authenticate.userByEmail(
          credentials.email,
          credentials.password
        );

        console.log(response);
        this.setToken(response.token);
        this.setcsrf_token(response.csrf_token);
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
      this.setcsrf_token(null);
      this.user = null;
      this.role = null;
      this.isAuthenticated = false;
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

    decodeToken(token: string) {
      try {
        return jwtDecode<{ role: string }>(token);
      } catch (error) {
        console.error('Erreur de décodage du token:', error);
        return null;
      }
    },
  },
});
