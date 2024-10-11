import { requests, responseBody } from '../config/axiosConfig';
import { User } from '../../models/user';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Users = {
  searchByEmailOrUsername: (email?: string, username?: string) => {
    const queryParams: string[] = [];
    if (email) queryParams.push(`email=${encodeURIComponent(email)}`);
    if (username) queryParams.push(`username=${encodeURIComponent(username)}`);
    const queryString =
      queryParams.length > 0 ? `?${queryParams.join('&')}` : '';

    return requests.get<User[]>(`users/search${queryString}`);
  },
  getUserSummary: (userId: number) => requests.get(`users/summary/${userId}`),
  list: (params: URLSearchParams) =>
    axios.get<PaginatedResult<User[]>>('users', { params }).then(responseBody),
  create: (user: User) => requests.post<User>('users', user),
  details: (id: number) => requests.get<User>(`users/${id}`),
  update: (id: number, user: User) =>
    requests.put<User>(`users/${id}`, { user }),
  remove: (id: number) => requests.delete(`users/${id}`),
};

export default Users;
