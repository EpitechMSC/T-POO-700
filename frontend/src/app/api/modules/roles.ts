import axios from 'axios';
import { requests, responseBody } from '../config/axiosConfig';
import { PaginatedResult } from '../../models/pagination';
import { Role } from '../../models/role';

const Roles = {
  list: (params: URLSearchParams): Promise<PaginatedResult<Role[]>> =>
    axios.get<PaginatedResult<Role[]>>('roles', { params }).then(responseBody),

  create: (role: Role) => requests.post<Role>('roles', { role }),

  details: (id: number) => requests.get<Role>(`roles/${id}`),

  update: (id: number, role: Role) =>
    requests.put<Role>(`roles/${id}`, { role }),

  remove: (id: number) => requests.delete(`roles/${id}`),
};

export default Roles;
