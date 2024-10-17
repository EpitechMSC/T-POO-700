import { defineStore } from 'pinia';
import router from '../../router/router';
import { SignalModel } from '../../models/signal';
import SignalMethods from '../../api/modules/signal';

export const useSignalStore = defineStore('signal', {
  state: (): SignalModel => ({
    name: 'BatSignal',
    status: false,
  }),

  getters: {
    getUser: (state): SignalModel | null => state,
  },

  actions: {
    async getStatus(): Promise<boolean> {
      try {
        const response = await SignalMethods.getSignalStatus();

        const data = response.data[0];
        return data.status;
      } catch (error) {
        console.error('Failed to retreive status:', error);
        throw new Error('Échec de la connexion');
      }
    },
    async toggleStatus(): Promise<void> {
      try {
        const response = await SignalMethods.getSignalStatus();
        const data = response.data[0];
        console.log(data);

        await SignalMethods.updateSignalStatus(data);
      } catch (error) {
        console.error('Failed to toggle status:', error);
        throw new Error('Échec de la connexion');
      }
    },
  },
});
