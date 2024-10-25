import { requests } from '../config/axiosConfig';
import { Team, TeamMember } from '../../models/team';

const Teams = {
  list: (): Promise<Team[]> => requests.get('teams'),

  getById: (id: number): Promise<Team> => requests.get(`teams/${id}`),

  getByUserId: (userId: number): Promise<Team[]> =>
    requests.get(`teams/user/${userId}`),

  create: (team: Team): Promise<Team> => requests.post('teams', team),

  update: (id: number, team: Team): Promise<Team> =>
    requests.put(`teams/${id}`, team),

  delete: (id: number): Promise<void> => requests.delete(`teams/${id}`),

  listMembers: (teamId: number): Promise<TeamMember[]> =>
    requests.get(`teams/${teamId}/members`),
};

export default Teams;
