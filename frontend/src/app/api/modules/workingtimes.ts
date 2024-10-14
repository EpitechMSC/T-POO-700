import { requests, responseBody } from '../config/axiosConfig';
import { WorkingTime } from '../../models/workingTime';
import axios from 'axios';
import { PaginatedResult } from '../../models/pagination';

const WorkingTimes = {
  getUserWorkingTime: (userID: number, id: string) =>
    requests.get<WorkingTime>(`workingtimes/${userID}/${id}`),

  getUserWeeklyWorkingTimes: (userId: number) =>
    requests.get(`working_times/${userId}/weekly`),
  getUserMonthlyWorkingTimes: (userId: number) =>
    requests.get(`working_times/${userId}/monthly`),
  getUserYearlyWorkingTimes: (userId: number) =>
    requests.get(`working_times/${userId}/yearly`),
  getUserWorkingTimesByUserId: (userId: number, params: URLSearchParams) =>
    axios
      .get<
        PaginatedResult<WorkingTime[]>
      >(`workingtimes/user/${userId}`, { params })
      .then(responseBody),
  getUserWorkingTimeStats: (
    userId: number
  ): Promise<{
    worked_today: number;
    worked_this_week: number;
    total_days_worked: number;
    worked_this_month: number;
    worked_last_month: number;
    percentage_change: number;
  }> => requests.get(`workingtimes/stats/${userId}`),
  list: (params: URLSearchParams) =>
    axios
      .get<PaginatedResult<WorkingTime[]>>('workingtimes', { params })
      .then(responseBody),
  create: (workingTime: WorkingTime) =>
    requests.post<WorkingTime>('workingtimes', workingTime),
  update: (id: number, workingTime: WorkingTime) =>
    requests.put<WorkingTime>(`workingtimes/${id}`, {
      working_time: workingTime,
    }),
  remove: (id: number) => requests.delete(`workingtimes/${id}`),
};

export default WorkingTimes;
