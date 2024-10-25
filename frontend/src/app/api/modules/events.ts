import { requests, responseBody } from '../config/axiosConfig';
import { Event } from '../../models/event';
import { PaginatedResult } from '../../models/pagination';
import axios from 'axios';

const Events = {
  list: (
    teamId: number,
    params: URLSearchParams
  ): Promise<PaginatedResult<Event[]>> =>
    axios
      .get<PaginatedResult<Event[]>>(`teams/${teamId}/events`, { params })
      .then(responseBody),
  listByUserId: (userId: number): Promise<Event[]> =>
    requests.get<Event[]>(`users/${userId}/events`),
  create: (teamId: number, event: Event): Promise<Event> =>
    requests.post<Event>(`teams/${teamId}/events`, { event }),
  update: (teamId: number, id: number, event: Event): Promise<Event> =>
    requests.put<Event>(`teams/${teamId}/events/${id}`, { event }),
  remove: (teamId: number, id: number): Promise<void> =>
    requests.delete(`teams/${teamId}/events/${id}`),
};

export default Events;
