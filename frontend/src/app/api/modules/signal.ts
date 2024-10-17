// src/api/modules/signal.ts
import { SignalModel } from '../../models/signal';
import { requests } from '../config/axiosConfig';

const SignalMethods = {
  getSignalStatus: (): Promise<SignalModel[]> =>
    requests.get<SignalModel[]>('signal'),
  updateSignalStatus: (data: SignalModel) =>
    requests.put<SignalModel>(`signal/` + data.id, {
      signal: {
        id: data.id,
        name: 'BatSignal',
        status: !data.status,
      },
    }),
};
export default SignalMethods;
