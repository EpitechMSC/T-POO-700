export interface Team {
  id: number;
  manager_id: number;
  createdAt: string;
  updatedAt: string;
}

export interface TeamMember {
  id: number;
  user_id: number;
  team_id: number;
  createdAt: string;
  updatedAt: string;
}
