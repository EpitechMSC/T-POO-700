// src/api/modules/authenticate.ts
import { User } from '../../models/user';
import { requests } from '../config/axiosConfig';

interface AuthResponse {
  token: string;
}

const Authenticate = {
  userByEmail: (email: string, password: string): Promise<AuthResponse> =>
    requests.post<AuthResponse>('login', { email, password }),

  userDetails: (): Promise<User> => requests.get<User>('users/me'),
};
export default Authenticate;
