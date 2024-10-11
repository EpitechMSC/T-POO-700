import { requests } from '../config/axiosConfig';
import { WorkingTime } from '../../models/workingTime';

const WorkingTimes = {
  getUserWorkingTime: (userID: string, id: string) =>
    requests.get<WorkingTime>(`workingtimes/${userID}/${id}`),
  getUserWeeklyWorkingTimes: (userId: string) =>
    requests.get(`working_times/${userId}/weekly`),
  getUserMonthlyWorkingTimes: (userId: string) =>
    requests.get(`working_times/${userId}/monthly`),
  getUserYearlyWorkingTimes: (userId: string) =>
    requests.get(`working_times/${userId}/yearly`),
  getUserWorkingTimesByUserId: (userId: string): Promise<WorkingTime[]> =>
    requests.get(`workingtimes/user/${userId}`),
  getUserWorkingTimeStats: (
    userId: string
  ): Promise<{
    worked_today: number;
    worked_this_week: number;
    total_days_worked: number;
    worked_this_month: number;
    worked_last_month: number;
    percentage_change: number;
  }> => requests.get(`workingtimes/stats/${userId}`),
  list: () => requests.get<WorkingTime[]>('workingtimes'),
  create: (workingTime: WorkingTime) =>
    requests.post<WorkingTime>('workingtimes', workingTime),
  update: (id: number, workingTime: WorkingTime) =>
    requests.put<WorkingTime>(`workingtimes/${id}`, {
      working_time: workingTime,
    }),
  remove: (id: number) => requests.delete(`workingtimes/${id}`),
};

export default WorkingTimes;
