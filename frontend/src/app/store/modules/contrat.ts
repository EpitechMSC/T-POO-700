import { defineStore } from 'pinia';
import { Contrat } from '../../models/contrat';
import agent from '../../api/agent';

interface ContratsState {
  contrats: Contrat[];
  contratOfConnectedUser: Contrat | null;
  loading: boolean;
  error: string | null;
}

export const useContratStore = defineStore('contrat', {
  state: (): ContratsState => ({
    contrats: [],
    contratOfConnectedUser: null,
    loading: false,
    error: null,
  }),
  getters: {
    clockCount: state => state.contrats.length,
  },
  actions: {
    async getContratInfo(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response: Contrat = await agent.Contrats.getContratSummary(id);

        this.contratOfConnectedUser = response;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || 'Erreur lors de la récupération du contrat';
        } else {
          this.error = 'Erreur inconnue lors de la récupération du contrat';
        }
      } finally {
        this.loading = false;
      }
    },
  },
});
