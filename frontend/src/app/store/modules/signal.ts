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
        const data = response.data;
        return data.status;
      } catch (error) {
        console.error('Login failed:', error);
        throw new Error('Échec de la connexion');
      }
    },
    async toggleStatus(): Promise<void> {
      try {
        const response = await SignalMethods.getSignalStatus();
        const data = response.data;

        await SignalMethods.updateSignalStatus(!data.status);
      } catch (error) {
        console.error('Login failed:', error);
        throw new Error('Échec de la connexion');
      }
    },
  },
});
