export interface Event {
  id?: number;
  title: string;
  start: Date;
  end: Date;
  all_day: boolean;
  team_id: number;
}

export interface CalendarEvent {
  title: string;
  start: Date | string;
  end: Date | string;
  allDay: boolean;
  id: number | undefined;
}
