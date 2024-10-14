// src/api/modules/authenticate.ts
import { requests } from '../config/axiosConfig';

interface AuthResponse {
  token: string;
}

const Authenticate = {
  userByEmail: (email: string): Promise<AuthResponse> =>
    requests.post<AuthResponse>('login', { email }),

  userDetails: () => requests.get('users/me'),
};

export default Authenticate;
