export interface Event {
  id?: number;
  title: string;
  start: Date;
  end: Date;
  all_day: boolean;
  team_id: number;
}
