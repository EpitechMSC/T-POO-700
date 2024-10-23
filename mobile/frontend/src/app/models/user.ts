export interface User {
  id: number;
  username: string;
  email: string;
  role: number;
}

export interface UserPayload {
  username: string;
  email: string;
}
