import { Contrat } from './contrat.ts';

export interface User {
  id: number;
  username: string;
  email: string;
  role: number;
  contrat: Contrat;
}

export interface UserPayload {
  username: string;
  email: string;
}
