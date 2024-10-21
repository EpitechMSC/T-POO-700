import { requests, responseBody } from '../config/axiosConfig';
import { WorkingTime, WorkingTimeStats } from '../../models/workingTime';
import axios from 'axios';
import { PaginatedResult } from '../../models/pagination';

const WorkingTimes = {
  getUserWorkingTime: (userID: number, id: string): Promise<WorkingTime> =>
    requests.get<WorkingTime>(`workingtimes/${userID}/${id}`),

  getUserWeeklyWorkingTimes: (userId: number): Promise<WorkingTime[]> =>
    requests.get<WorkingTime[]>(`workingtimes/${userId}/weekly`),

  getUserMonthlyWorkingTimes: (userId: number): Promise<WorkingTime[]> =>
    requests.get<WorkingTime[]>(`workingtimes/${userId}/monthly`),

  getUserYearlyWorkingTimes: (userId: number): Promise<WorkingTime[]> =>
    requests.get<WorkingTime[]>(`workingtimes/${userId}/yearly`),

  getUserWorkingTimesByUserId: (
    userId: number,
    params: URLSearchParams
  ): Promise<PaginatedResult<WorkingTime[]>> =>
    axios
      .get<
        PaginatedResult<WorkingTime[]>
      >(`workingtimes/user/${userId}`, { params })
      .then(responseBody),

  getUserWorkingTimeStats: (userId: number): Promise<WorkingTimeStats> =>
    requests.get<WorkingTimeStats>(`workingtimes/stats/${userId}`),

  list: (params: URLSearchParams): Promise<PaginatedResult<WorkingTime[]>> =>
    axios
      .get<PaginatedResult<WorkingTime[]>>('workingtimes', { params })
      .then(responseBody),

  create: (workingTime: WorkingTime): Promise<WorkingTime> =>
    requests.post<WorkingTime>('workingtimes', workingTime),

  update: (id: number, workingTime: WorkingTime): Promise<WorkingTime> =>
    requests.put<WorkingTime>(`workingtimes/${id}`, {
      working_time: workingTime,
    }),

  remove: (id: number): Promise<void> => requests.delete(`workingtimes/${id}`),
};

export default WorkingTimes;
