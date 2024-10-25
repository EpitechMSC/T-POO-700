import { defineStore } from 'pinia';
import { Team, TeamMember } from '../../models/team';
import agent from '../../api/agent';

interface TeamState {
  teams: Team[];
  team: Team | null;
  teamMembers: TeamMember[];
  loading: boolean;
  error: string | null;
}

export const useTeamStore = defineStore('team', {
  state: (): TeamState => ({
    teams: [],
    team: null,
    teamMembers: [],
    loading: false,
    error: null,
  }),

  actions: {
    async fetchTeams(): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const teams = await agent.Teams.list();
        this.teams = teams;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || 'Erreur lors de la récupération des équipes';
        } else {
          this.error = 'Erreur inconnue lors de la récupération des équipes';
        }
      } finally {
        this.loading = false;
      }
    },

    async fetchTeamById(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const team = await agent.Teams.getById(id);
        this.team = team;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la récupération de l'équipe";
        } else {
          this.error = "Erreur inconnue lors de la récupération de l'équipe";
        }
      } finally {
        this.loading = false;
      }
    },

    async fetchTeamByUserId(userId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const team = await agent.Teams.getByUserId(userId);
        this.teams = team;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message ||
            "Erreur lors de la récupération de l'équipe par utilisateur";
        } else {
          this.error =
            "Erreur inconnue lors de la récupération de l'équipe par utilisateur";
        }
      } finally {
        this.loading = false;
      }
    },

    async createTeam(team: Team): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const newTeam = await agent.Teams.create(team);
        this.teams.push(newTeam);
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error = err.message || "Erreur lors de la création de l'équipe";
        } else {
          this.error = "Erreur inconnue lors de la création de l'équipe";
        }
      } finally {
        this.loading = false;
      }
    },

    async updateTeam(id: number, team: Team): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const updatedTeam = await agent.Teams.update(id, team);
        const index = this.teams.findIndex(t => t.id === id);
        if (index !== -1) {
          this.teams[index] = updatedTeam;
        }
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la mise à jour de l'équipe";
        } else {
          this.error = "Erreur inconnue lors de la mise à jour de l'équipe";
        }
      } finally {
        this.loading = false;
      }
    },

    async deleteTeam(id: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        await agent.Teams.delete(id);
        this.teams = this.teams.filter(t => t.id !== id);
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message || "Erreur lors de la suppression de l'équipe";
        } else {
          this.error = "Erreur inconnue lors de la suppression de l'équipe";
        }
      } finally {
        this.loading = false;
      }
    },

    async fetchTeamMembers(teamId: number): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const members = await agent.Teams.listMembers(teamId);
        this.teamMembers = members;
      } catch (err: unknown) {
        if (err instanceof Error) {
          this.error =
            err.message ||
            "Erreur lors de la récupération des membres de l'équipe";
        } else {
          this.error =
            "Erreur inconnue lors de la récupération des membres de l'équipe";
        }
      } finally {
        this.loading = false;
      }
    },
  },
});
