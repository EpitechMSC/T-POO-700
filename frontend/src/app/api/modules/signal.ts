// src/api/modules/signal.ts
import { SignalModel } from '../../models/signal';
import { requests } from '../config/axiosConfig';

const SignalMethods = {
  getSignalStatus: (): Promise<SignalModel> =>
    requests.get<SignalModel>('signal/1'),
  updateSignalStatus: (status: boolean) =>
    requests.put<SignalModel>(`signal/1`, {signal:{
      name: 'BatSignal',
      status: status,
    }}),
};
export default SignalMethods;
