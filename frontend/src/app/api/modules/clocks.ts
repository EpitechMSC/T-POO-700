import { requests, responseBody } from '../config/axiosConfig';
import { Clock } from '../../models/clock';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Clocks = {
  list: (params: URLSearchParams): Promise<PaginatedResult<Clock[]>> =>
    axios
      .get<PaginatedResult<Clock[]>>('clocks', { params })
      .then(responseBody),
  create: (clock: Clock): Promise<Clock> =>
    requests.post<Clock>('clocks', clock),
  update: (id: number, clock: Clock): Promise<Clock> =>
    requests.put<Clock>(`clocks/${id}`, { clock }),
  remove: (id: number): Promise<void> => requests.delete(`clocks/${id}`),
  getLastByUserId: (id: number): Promise<Clock> =>
    requests.get(`clocks/get_last/${id}`),
};

export default Clocks;
