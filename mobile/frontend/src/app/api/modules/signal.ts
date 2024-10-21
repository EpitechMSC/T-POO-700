// src/api/modules/signal.ts
import { SignalModel, ApiResponse } from '../../models/signal';
import { requests } from '../config/axiosConfig';

const SignalMethods = {
  getSignalStatus: (): Promise<ApiResponse> =>
    requests.get<ApiResponse>('signal'),
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
