import { requests } from '../config/axiosConfig';
import { Clock } from '../../models/clock';

const Clocks = {
  list: () => requests.get<Clock[]>('clocks'),
  create: (clock: Clock) => requests.post<Clock>('clocks', clock),
  update: (id: number, clock: Clock) =>
    requests.put<Clock>(`clocks/${id}`, { clock }),
  remove: (id: number) => requests.delete(`clocks/${id}`),
};

export default Clocks;
