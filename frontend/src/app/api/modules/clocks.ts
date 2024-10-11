import { requests, responseBody } from '../config/axiosConfig';
import { Clock } from '../../models/clock';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Clocks = {
  list: (params: URLSearchParams) =>
    axios
      .get<PaginatedResult<Clock[]>>('clocks', { params })
      .then(responseBody),
  create: (clock: Clock) => requests.post<Clock>('clocks', clock),
  update: (id: number, clock: Clock) =>
    requests.put<Clock>(`clocks/${id}`, { clock }),
  remove: (id: number) => requests.delete(`clocks/${id}`),
};

export default Clocks;
