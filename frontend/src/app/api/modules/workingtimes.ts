import { requests } from '../config/axiosConfig';
import { WorkingTime } from '../../models/workingTime';

const WorkingTimes = {
  getUserWorkingTime: (userID: string, id: string) =>
    requests.get<WorkingTime>(`workingtimes/${userID}/${id}`),
  list: () => requests.get<WorkingTime[]>('workingtimes'),
  create: (workingTime: WorkingTime) =>
    requests.post<WorkingTime>('workingtimes', workingTime),
  update: (id: number, workingTime: WorkingTime) =>
    requests.put<WorkingTime>(`workingtimes/${id}`, workingTime),
  remove: (id: number) => requests.delete(`workingtimes/${id}`),
};

export default WorkingTimes;
