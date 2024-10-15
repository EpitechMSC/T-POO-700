// src/api/agent.ts

import { requests, responseBody } from '../config/axiosConfig';
import { User, UserPayload } from '../../models/user';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Users = {
  searchByEmailOrUsername: (
    params: URLSearchParams
  ): Promise<PaginatedResult<User[]>> => {
    return axios
      .get<PaginatedResult<User[]>>(`users/search`, { params })
      .then(responseBody);
  },
  getUserSummary: (userId: number) => requests.get(`users/summary/${userId}`),
  list: (params: URLSearchParams): Promise<PaginatedResult<User[]>> =>
    axios.get<PaginatedResult<User[]>>('users', { params }).then(responseBody),
  create: (user: UserPayload) => requests.post<User>('users', { user }),
  details: (id: number) => requests.get<User>(`users/${id}`),
  update: (id: number, user: User) =>
    requests.put<User>(`users/${id}`, { user }),
  remove: (id: number) => requests.delete(`users/${id}`),
};

export default Users;
