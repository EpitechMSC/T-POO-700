import { User } from './user';

export interface AuthenticateState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
}

export interface LoginResponse {
  token: string;
}

export interface Credentials {
  email: string;
  password: string;
}